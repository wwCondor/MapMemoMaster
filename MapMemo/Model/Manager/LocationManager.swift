//
//  LocationManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 21/11/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationDataDelegate: class {
    func updateCurrentLocation(to newLocation: CLLocation)
    func updateCurrentHeading(to newHeading: CLHeading)
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    weak var delegate: LocationDataDelegate?
    
    var lastLocation: CLLocation?
    var lastHeading: CLHeading?
    var hasLocationAuthorization: Bool = false
    
    func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location Services are Disabled") // inform user services disable and inquire if use wants to enable these
            return
        }
        checkLocationAuthorization()
//        configureLocationManager()
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            hasLocationAuthorization = false
        case .authorizedAlways, .authorizedWhenInUse:
            hasLocationAuthorization = true
            configureLocationManager()
        default: break
        }
    }
    
    func configureLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 25
        manager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, newLocation != lastLocation else { return }
        lastLocation = newLocation
        
        guard let delegate = delegate else { return }
        delegate.updateCurrentLocation(to: newLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        guard newHeading != lastHeading else { return }
        lastHeading = newHeading
        
        guard let delegate = delegate else { return }
        delegate.updateCurrentHeading(to: newHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServices()
    }
}
