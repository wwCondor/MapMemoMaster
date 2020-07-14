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

class MapVC: UIViewController {
    
    private var locationTitle: String?
    private var locationSubtitle: String?
    private var lastLocation: CLLocation?
    private var reminders: [Reminder]    = []
    private var locationAuthorized: Bool = false
    
    private let updateRemindersKey       = Notification.Name(rawValue: Key.updateReminders)
    private let managedObjectContext     = CoreDataManager.shared.managedObjectContext
    private let notificationManager      = NotificationManager.shared
    private let locationManager          = CLLocationManager()
    private let regionInMeters: Double   = 2500
    
    private let mapView                  = MMMapView()
    private let compassBackgroundView    = MMBackgroundView(backgroundColor: .systemBackground, cornerRadius: Configuration.compassBackgroundSize/2)
    private let compass                  = MMCompassImageView(frame: .zero)
    
    
//    private var mapCamera = MKMapCamera()
//    private let testButton              = MMTwoLineButton(title: "Main", subtitle: "Some subtitle", mode: .split) // MARK: Delete
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        mapView.delegate = self
        notificationManager.delegate = self
        
        addObserver()
        getActiveReminders()
        checkLocationServices()
        
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
        print("Retrieving active reminders")
        do {
            reminders = try managedObjectContext.fetch(NSFetchRequest(entityName: "Reminder"))
            print("Total reminders: \(reminders.count)")
        } catch {
            presentMMAlertOnMainThread(title: "Reminder Fetch Error", message: MMError.failedFetch.localizedDescription, buttonTitle: "OK")
        }
        print("Retrieved active reminders")
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
            mapView.showsUserLocation = true // Handled in class declaration
            centerMapOnUser()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            addRemindersToMap(reminders: reminders) // Handle inside fetchReminders method?
        @unknown default: break
        }
        
        #warning("Implement no authorization path -> Settings")
//        updateUIForAuthorization(status: locationAuthorized)
    }
    
    /// Updates UI for authorization status
//    private func updateUIForAuthorization(status: Bool) {
//        switch status {
//        case true: print("Hide settings shortcut")
//        case false: print("Show settings shortcut")
//        }
//    }
    
    // MARK: Add Reminders
    private func addRemindersToMap(reminders: [Reminder]) {
        guard !reminders.isEmpty else { return }
        
        for reminder in reminders {
            if reminder.isActive == true {
                createAnnotation(for: reminder)
                createLocationBubble(for: reminder)
                notificationManager.addNotificationRequest(for: reminder)
            }
        }
        
//        print("***")
//        print("Regions currently monitored: \(locationManager.monitoredRegions.count)")
//        print("***")
    }
    
    #warning("pinTintColor UIColor.white will never be used")
    private func createAnnotation(for reminder: Reminder) {
        let annotation          = MMPointAnnotation()
        annotation.title        = reminder.identifier
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
    
    // MARK: Update Reminders
    @objc private func updateMapForReminders(sender: NotificationCenter) {
        print("Updating reminders")
        removeReminders()
        getActiveReminders()
        addRemindersToMap(reminders: reminders) // move inside fetchReminders method?
    }
    
    private func removeReminders() {
        print("Started removing reminders")
        reminders.removeAll()
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        let regions = locationManager.monitoredRegions
        for region in regions { locationManager.stopMonitoring(for: region) }
        print("Finished removing reminders")
    }
    
    private func getLocationInfo() {
        guard let location = lastLocation else { return }
        
        let geoCoder = CLGeocoder()

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemark         = placemarks?.last else { return }
            guard let name              = placemark.name else { return }
            guard let streetAddress     = placemark.thoroughfare, let streetNumber = placemark.subThoroughfare?.lastCharacterLowerCased() else { return }
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
    
//    private func getCurrentLocation() -> CLLocationCoordinate2D? {
//        guard let location = locationManager.location?.coordinate else {
//            presentMMAlertOnMainThread(title: "No Coordinate", message: MMError.noCoordinate.localizedDescription, buttonTitle: "OK")
//            return nil }
//        return location
//    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    private func centerMapOnUser() {
        guard let location = lastLocation else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
//    private func centerMapOnPin(for reminder: Reminder) {
//        let center = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
//    }
    
    private func annotationTapped(at type: AnnotationType, for reminder: Reminder?) {
        switch type {
        case .pinLocation: presentMenuForPinLocation(for: reminder)
        case .currentLocation: presentMenuForCurrentLocation()
        }
    }
    
    private func presentMenuForPinLocation(for reminder: Reminder?) {
        DispatchQueue.main.async {
            guard let reminder = reminder else { return }
            let annotationMenuVC = MMAnnotationVC()
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
            let annotationMenuVC = MMAnnotationVC()
            annotationMenuVC.modalPresentationStyle = .overFullScreen
            annotationMenuVC.modalTransitionStyle   = .crossDissolve
            annotationMenuVC.modeSelected           = .currentLocation
            annotationMenuVC.locationNameInfo       = self.locationTitle
            annotationMenuVC.locationAddressInfo    = self.locationSubtitle
            annotationMenuVC.delegate               = self
            self.centerMapOnUser()
            self.present(annotationMenuVC, animated: true)
        }
    }
    
    private func presentReminderVC(mode: ReminderMode, reminder: Reminder?) {
        guard let location = lastLocation else {
            presentMMAlertOnMainThread(title: "Coordinates not found", message: MMError.unableToObtainLocation.localizedDescription, buttonTitle: "OK")
            return
        }
                
        let latitude   = location.coordinate.latitude
        let longitude  = location.coordinate.longitude
        
        let reminderVC = ReminderVC(mode: mode, reminder: reminder)
        reminderVC.locationName      = self.locationTitle
        reminderVC.locationAddress   = self.locationSubtitle
        reminderVC.reminderLatitude  = latitude
        reminderVC.reminderLongitude = longitude
        
        let navigationController = UINavigationController(rootViewController: reminderVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
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
        guard let newLocation = userLocation.location else { return }
        lastLocation = newLocation
        getLocationInfo()
        print("Location changed")
//        mapView.userLocation.title = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        let locationCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        centerMap(on: locationCoordinate)

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
//        guard let calloutView = view.subviews.first else { return }
//        let userLocationTapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTapUserLocation(sender:)))
//        let pinTapGesutre = UITapGestureRecognizer(target: self, action: #selector(userDidTapPinLocation(sender:)))
//        calloutView.addGestureRecognizer(userLocationTapGesture)
//        calloutView.addGestureRecognizer(pinTapGesutre)
        
        if view.annotation is MKUserLocation {
            annotationTapped(at: .currentLocation, for: nil)
        } else {
            guard let reminder = findReminder(for: view) else  { return }
//            let location = findLocation(for: view)
//            guard let title = view.annotation?.title, let identifier = title else { return }
//            guard let reminder = managedObjectContext.fetchReminderWith(identifier: identifier, context: managedObjectContext) else { return }
            let location = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
            centerMap(on: location)
            annotationTapped(at: .pinLocation, for: reminder)
        }
        mapView.deselectAnnotation(view as? MKAnnotation, animated: true)
    }
    
    private func findReminder(for view: MKAnnotationView) -> Reminder? {
        guard let title = view.annotation?.title, let identifier = title else { return nil}
        guard let reminder = managedObjectContext.fetchReminderWith(identifier: identifier, context: managedObjectContext) else { return nil}
        return reminder
    }
    
//    @objc private func userDidTapUserLocation(sender: UITapGestureRecognizer) {
//        print("User location was tapped")
////        switch view {
////            case
////        }
//    }
//
//    @objc private func userDidTapPinLocation(sender: UITapGestureRecognizer) {
//        print("Pin annotation was tapped")
//    }
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
    
    func userTappedAddReminderButton() { presentReminderVC(mode: .annotation, reminder: nil) }
}

extension MapVC: NotificationManagerDelegate {
    func informLocationManager(for region: CLCircularRegion) {
        locationManager.startMonitoring(for: region)
    }
}
