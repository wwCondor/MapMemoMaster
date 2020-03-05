//
//  MapVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
import UserNotifications

class MapVC: UIViewController {
    
    private var locationTitle: String?
    private var locationSubtitle: String?
    private var lastLocation: CLLocation?
    private var reminders: [Reminder] = []
    private var locationAuthorized: Bool = false
    
    private let updateRemindersKey      = Notification.Name(rawValue: Key.updateReminders)
//    private let notificationCenter      = UNUserNotificationCenter.current()
    private let managedObjectContext    = CoreDataManager.shared.managedObjectContext
    
    private let notificationManager     = NotificationManager.shared
    
    private let locationManager         = CLLocationManager()
    private let regionInMeters: Double  = 2500
    
    private let mapView                 = MMMapView()
    private let compassBackgroundView   = MMBackgroundView(backgroundColor: .systemBackground, cornerRadius: Configuration.compassBackgroundSize/2)
    private let compass                 = MMCompassImageView(frame: .zero)
    
//    private var mapCamera = MKMapCamera()
//    private let testButton              = MMTwoLineButton(title: "Main", subtitle: "Some subtitle", mode: .split) // MARK: Delete
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        addObserver()
//        setDelegates()
        getActiveReminders()
        checkLocationServices()
        
        mapView.delegate = self
        notificationManager.delegate = self
//        layoutTestObject()
//        configureTestButton() // MARK: Delete
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
//    private func configureTestButton() { // MARK: Delete
//        testButton.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
//    }
    
//    @objc private func testButtonTapped(sender: MMButton) { // MARK: Delete
//        presentMMAlertOnMainThread(title: "Test", message: "This is the test content", buttonTitle: "Ok")
//    }
    
//    private func layoutTestObject() {
//        view.addSubview(testButton) // MARK: Delete
//        
//        NSLayoutConstraint.activate([
//            testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            testButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            testButton.heightAnchor.constraint(equalToConstant: 60),
//        ])
//    }
    
    private func layoutUI() {
        view.addSubviews(mapView, compassBackgroundView, compass)
        mapView.pinToEdges(of: view)
        
        let padding: CGFloat = 30
        
        NSLayoutConstraint.activate([
            compassBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            compassBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            compassBackgroundView.widthAnchor.constraint(equalToConstant: Configuration.compassBackgroundSize),
            compassBackgroundView.heightAnchor.constraint(equalToConstant: Configuration.compassBackgroundSize),
            
            compass.centerXAnchor.constraint(equalTo: compassBackgroundView.centerXAnchor),
            compass.centerYAnchor.constraint(equalTo: compassBackgroundView.centerYAnchor),
            compass.widthAnchor.constraint(equalToConstant: Configuration.compassSize),
            compass.heightAnchor.constraint(equalToConstant: Configuration.compassSize),
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateMapForReminders), name: updateRemindersKey, object: nil)
    }
    
//    private func setDelegates() {
//        mapView.delegate = self
//        notificationManager.delegate = self
////        mapView.camera = mapCamera
//    }


//    private func setMapCamera() {
//        let currentLocation =
//    }
    
    private func getActiveReminders() {
        do {
            reminders = try managedObjectContext.fetch(NSFetchRequest(entityName: "Reminder"))
            addRemindersToMap(reminders: reminders)
            print("Total reminders: \(reminders.count)")//"; \(reminders)")
        } catch {
            presentMMAlertOnMainThread(title: "Reminder Fetch Error", message: MMError.failedFetch.localizedDescription, buttonTitle: "OK")
        }
    }
    
    private func checkLocationServices() {
        print("Checking location services")
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location Services are Disabled")
            presentFailedPermissionActionSheet(description: MMError.locationServicesDisabled.localizedDescription , viewController: self)
            return
        }
        
        print("Location Services are Enabled")
        configureLocationManager()
        checkLocationAuthorization()
    }
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 25
    }
    
    private func checkLocationAuthorization() {
        print("Checking Location Authorization")
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            print("Requesting Authorization")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Authorization restricted or denied")
            locationAuthorized = false
            presentFailedPermissionActionSheet(description: MMError.locationAuthorizationDenied.localizedDescription , viewController: self)
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized")
            locationAuthorized = true
//            mapView.showsUserLocation = true // Handled in class declaration
            centerMapOnUser()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
//            addRemindersToMap(reminders: reminders) // Handled inside fetchReminders method
        @unknown default: break
        }
        
        updateUIForAuthorization(status: locationAuthorized)
    }
    
    private func updateUIForAuthorization(status: Bool) {
        switch status {
        case true: print("Hide settings shortcut")
        case false: print("Show settings shortcut")
        }
    }
    
    // MARK: Add Reminders
    private func addRemindersToMap(reminders: [Reminder]) {
        guard !reminders.isEmpty else { return }
        
        for reminder in reminders {
            if reminder.isActive == true {
                createAnnotation(for: reminder)
                createLocationBubble(for: reminder)
//                notificationManager.createNotificationRequest(for: reminder)
                createNotification(for: reminder)
            }
        }
        
//        print("***")
//        print("Regions currently monitored: \(locationManager.monitoredRegions.count)")
//        print("***")
    }
    
    #warning("pinTintColor UIColor.white will never be used")
    private func createAnnotation(for reminder: Reminder) {
        let annotation          = MMPointAnnotation()
        annotation.title        = reminder.title
        annotation.subtitle     = reminder.message
        annotation.pinTintColor = reminder.isActive ? UIColor.systemPink : UIColor.white
        annotation.coordinate   = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
        mapView.addAnnotation(annotation)
    }
    
    private func createLocationBubble(for reminder: Reminder) {
        let bubble = MKCircle(center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude), radius: reminder.bubbleRadius)
        mapView.addOverlay(bubble)
        mapView.reloadInputViews()
    }
    
    private func createNotification(for reminder: Reminder) {
        guard let request = notificationManager.createNotificationRequest(for: reminder) else {
            print("Error creating request")
            return
        }
//        guard let identifier        = reminder.locationName else { return }
//        guard let notificationTitle = reminder.title else { return }
//        guard let message           = reminder.message else { return }
//
//        let center = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
//        let region = CLCircularRegion(center: center, radius: reminder.bubbleRadius, identifier: identifier)
//
//        switch reminder.triggerOnEntry {
//        case true:
////            region.notifyOnEntry = true // Should be enough to set false only since true is default - Test
//            region.notifyOnExit  = false
//        case false:
//            region.notifyOnEntry = false
////            region.notifyOnExit  = true
//        }
//
//        locationManager.startMonitoring(for: region)
//
//        let content         = UNMutableNotificationContent()
//        let messagePrefix   = reminder.triggerOnEntry ? "Arrived at" : "Leaving"
//        content.title       = notificationTitle
//        content.body        = "\(messagePrefix) \(identifier): \(message)"
//        content.sound       = UNNotificationSound.default
//
//        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: reminder.isRepeating)
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: locationTrigger)
        
        notificationManager.center.add(request) { (error) in
            if error != nil {
                if UIApplication.shared.applicationState == .active {
                    self.presentMMAlertOnMainThread(title: "Notifcation Error", message: MMError.addNotificationFailed.localizedDescription, buttonTitle: "OK")
                }
            }
        }
    }
    
    // MARK: Update Reminders
    @objc private func updateMapForReminders(sender: NotificationCenter) {
        print("Updating reminders")
        removeReminders()
//        getActiveReminders()
//        addRemindersToMap(reminders: reminders) // moved inside fetchReminders method
    }
    
    private func removeReminders() {
        reminders.removeAll()
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        let regions = locationManager.monitoredRegions
        for region in regions { locationManager.stopMonitoring(for: region) }
        getActiveReminders()
    }
    
    private func getLocationInfo() {
        guard let location = getCurrentLocation() else { return }
        
//        let information = Helper.getInformation(for: location)
//        self.locationTitle = information.first
//        self.locationSubtitle = information.last
        
        let geoCoder = CLGeocoder()

        let latitude = location.latitude
        let longitude = location.longitude

        geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemark         = placemarks?.last else { return }
            guard let name              = placemark.name else { return }
            guard let streetAddress     = placemark.thoroughfare, let streetNumber = placemark.subThoroughfare else { return }
            guard let city              = placemark.locality else { return }
            guard let isoCountryCode    = placemark.isoCountryCode else { return }

            self.locationTitle = name

            if "\(name)" == "\(streetAddress) \(streetNumber)" {
                self.locationSubtitle = "\(city) (\(isoCountryCode))"
            } else {
                self.locationSubtitle = "\(streetAddress) \(streetNumber), \(city) (\(isoCountryCode))"
            }
        }
    }
    
    private func getCurrentLocation() -> CLLocationCoordinate2D? {
        guard let location = locationManager.location?.coordinate else { return nil }
        return location
    }
    
    private func centerMapOnUser() {
        guard let location = getCurrentLocation() else { return }
//        print(location.getInformation())
        let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    private func centerMapOnPin(for reminder: Reminder) {
        let center = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
        //        mapView.setCenter(center, animated: true)
    }
    
    private func annotationTapped(at mode: AnnotationMode, for reminder: Reminder?) {
        switch mode {
        case .pinLocation: presentMenuForPinLocation(for: reminder)
        case .myLocation: presentMenuForCurrentLocation()
        }
    }
    
    private func presentMenuForPinLocation(for reminder: Reminder?) {
        DispatchQueue.main.async {
            guard let reminder = reminder else { return }
//            let annotationMenuVC = MMAnnotationVC(mode: .pinLocation, reminder: reminder, title: nil, subtitle: nil)
            
            let annotationMenuVC = MMAnnotationVC()
//            let annotationMenuVC = MMAnnotationVC(mode: .pinLocation, reminder: reminder, location: nil)
            annotationMenuVC.modalPresentationStyle = .overFullScreen
            annotationMenuVC.modalTransitionStyle   = .crossDissolve
            annotationMenuVC.reminder               = reminder
            annotationMenuVC.modeSelected           = .pinLocation
            annotationMenuVC.delegate               = self
            self.present(annotationMenuVC, animated: true)
        }
    }
    
    private func presentMenuForCurrentLocation() {
        DispatchQueue.main.async {
            guard let titleInfo = self.locationTitle, let subtitleInfo = self.locationSubtitle else {
                self.presentMMAlertOnMainThread(title: "Location info not found", message: MMError.locationInfoNotFound.localizedDescription, buttonTitle: "OK")
                return
            }
            let annotationMenuVC = MMAnnotationVC()
//            guard let lastlocation = self.lastLocation else { return }
//            let annotationMenuVC = MMAnnotationVC(mode: .myLocation, reminder: nil, location: location)
//            let annotationMenuVC = MMAnnotationVC(mode: .myLocation, reminder: nil, title: self.locationTitle, subtitle: self.locationSubtitle)
            annotationMenuVC.modalPresentationStyle = .overFullScreen
            annotationMenuVC.modalTransitionStyle   = .crossDissolve
            annotationMenuVC.titleInfo              = titleInfo
            annotationMenuVC.subtitleInfo           = subtitleInfo
            annotationMenuVC.modeSelected           = .myLocation
            annotationMenuVC.delegate               = self
            self.present(annotationMenuVC, animated: true)
        }
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
//    private func setCamera(for location: CLLocationCoordinate2D) {
//        mapCamera.centerCoordinate = location
//        mapCamera.pitch = 20
//        mapCamera.altitude = 1000
//        mapCamera.heading = 45
//    }
}

extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.3) {
            let angle = CGFloat(newHeading.trueHeading).degreesToRadians
            self.compass.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.userLocation.title = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.last else { return }
        lastLocation = currentLocation
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
//        setCamera(for: center)
//        getLocationInfo()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "AnnotationId"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = false
//            annotationView?.isEnabled = false
            #warning("Edited - Test")
        } else { 
            annotationView?.annotation = annotation
        }
        if let annotation = annotation as? MMPointAnnotation {
            annotationView?.pinTintColor = annotation.pinTintColor
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let bubble = MKCircleRenderer(overlay: overlay)
        bubble.strokeColor  = UIColor.systemPink.withAlphaComponent(0.8)
        bubble.fillColor    = UIColor.systemPink.withAlphaComponent(0.4)
        bubble.lineWidth    = 2
        return bubble
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            getLocationInfo()
            centerMapOnUser()
            annotationTapped(at: .myLocation, for: nil)
        } else {
            guard let annotationTitle = view.annotation?.title, let title = annotationTitle else { return }
            guard let reminder = managedObjectContext.fetchReminderWith(title: title, context: managedObjectContext) else { return }
            centerMapOnPin(for: reminder)
            annotationTapped(at: .pinLocation, for: reminder)
        }
        mapView.deselectAnnotation(view as? MKAnnotation, animated: true)
    }
}

class MMPointAnnotation: MKPointAnnotation {
    var pinTintColor: UIColor?
}

extension MapVC: AnnotationDelegate {
    func userTappedShareButton() {
        print("User wants to share location")
    }
    
    func userTappedNavigationButton() {
        print("User wants to navigate to reminder")
    }
    
    func userTappedAddReminderButton() {
        presentReminderVC(mode: .annotation, reminder: nil)
        print("User wants to create reminder for current location")
    }
    
    private func presentReminderVC(mode: ReminderMode, reminder: Reminder?) {
        guard let location = lastLocation else {
            presentMMAlertOnMainThread(title: "Coordinates not found", message: MMError.unableToObtainLocation.localizedDescription, buttonTitle: "OK")
            return
        }
                
        let latitude   = location.coordinate.latitude
        let longitude  = location.coordinate.longitude
        
        let reminderVC = ReminderVC(mode: mode, reminder: reminder)
        reminderVC.locationName      = locationTitle
        reminderVC.locationAddress   = locationSubtitle
        reminderVC.reminderLatitude  = latitude
        reminderVC.reminderLongitude = longitude
        
        let navigationController = UINavigationController(rootViewController: reminderVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension MapVC: NotificationManagerDelegate {
    func informLocationManager(for region: CLCircularRegion) {
        locationManager.startMonitoring(for: region)
    }
}
