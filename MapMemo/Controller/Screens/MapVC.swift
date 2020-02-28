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
    
    private var lastLocation: CLLocation?
    private var reminders: [Reminder] = []
    private var locationAuthorized: Bool = false
    
    private let updateRemindersKey      = Notification.Name(rawValue: Key.updateReminders)
    private let notificationCenter      = UNUserNotificationCenter.current()
    private let managedObjectContext    = CoreDataManager.shared.managedObjectContext
    private let locationManager         = CLLocationManager()
    private let regionInMeters: Double  = 2500
    
    private let mapView                 = MMMapView()
    private let compassBackgroundView   = MMBackgroundView(backgroundColor: .systemBackground, cornerRadius: Configuration.compassBackgroundSize/2)
    private let compass                 = MMCompassImageView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        addObserver()
        configureMapView()
        getActiveReminders()
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(updateRemindersOnMap), name: updateRemindersKey, object: nil)
    }
    
    private func configureMapView() {
        mapView.delegate = self
    }

    private func getActiveReminders() {
        do {
            reminders = try managedObjectContext.fetch(NSFetchRequest(entityName: "Reminder"))
            print("Active reminders: \(reminders.count)")
        } catch {
            presentMMAlertOnMainThread(title: "Reminder Fetch Error", message: MMError.failedFetch.localizedDescription, buttonTitle: "OK")
        }
    }
    
    private func checkLocationServices() {
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
            mapView.showsUserLocation = true // Handle in class declaration?
            centerMapOnUser()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            addRemindersToMap(reminders: reminders)
        @unknown default: break
        }
        
        updateUIForAuthorization(status: locationAuthorized)
    }
    
    private func centerMapOnUser() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
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
                createNotification(for: reminder)
            }
        }
    }
    
    #warning("pinTintColor UIColor.white will never be used")
    private func createAnnotation(for reminder: Reminder) {
        let annotation = CustomPointAnnotation()
        annotation.title = reminder.title
        annotation.subtitle = reminder.message
        annotation.pinTintColor = reminder.isActive ? UIColor.systemPink : UIColor.white
        annotation.coordinate = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
        mapView.addAnnotation(annotation)
    }
    
    private func createLocationBubble(for reminder: Reminder) {
        let bubble = MKCircle(center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude), radius: reminder.bubbleRadius)
        mapView.addOverlay(bubble)
        mapView.reloadInputViews()
    }
    
    private func createNotification(for reminder: Reminder) {
        guard let identifier = reminder.locationName else { return }
        guard let notificationTitle = reminder.title else { return }
        guard let message = reminder.message else { return }
        
        let region = CLCircularRegion.init(center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude), radius: reminder.bubbleRadius, identifier: identifier)
        
        switch reminder.triggerOnEntry {
        case true:
            region.notifyOnEntry = true
            region.notifyOnExit = false
        case false:
            region.notifyOnEntry = false
            region.notifyOnExit = true
        }
        
        locationManager.startMonitoring(for: region)
        
        let content = UNMutableNotificationContent()
        let messagePrefix = reminder.triggerOnEntry ? "Arrived at" : "Leaving"
        content.title = notificationTitle
        content.body = "\(messagePrefix) \(identifier): \(message)"
        content.sound = UNNotificationSound.default
        
        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: reminder.isRepeating)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: locationTrigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                if UIApplication.shared.applicationState == .active {
                    self.presentMMAlertOnMainThread(title: "Notifcation Error", message: MMError.addNotificationFailed.localizedDescription, buttonTitle: "OK")
                }
            }
        }
    }
    
    // MARK: Update Reminders
    @objc private func updateRemindersOnMap(sender: NotificationCenter) {
        print("Updating reminders")
        removeReminders()
        getActiveReminders()
        addRemindersToMap(reminders: reminders)
    }
    
    private func removeReminders() {
        reminders.removeAll()
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        let regions = locationManager.monitoredRegions
        for region in regions { locationManager.stopMonitoring(for: region) }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.3) {
            let angle = CGFloat(newHeading.trueHeading).degreesToRadians
            self.compass.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
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
            annotationView?.canShowCallout = true
        } else { 
            annotationView?.annotation = annotation
        }
        if let annotation = annotation as? CustomPointAnnotation {
            annotationView?.pinTintColor = annotation.pinTintColor
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let bubble = MKCircleRenderer(overlay: overlay)
        bubble.strokeColor = UIColor.systemPink
        bubble.fillColor = UIColor.systemPink.withAlphaComponent(0.2)
        bubble.lineWidth = 2
        return bubble
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var pinTintColor: UIColor?
}
