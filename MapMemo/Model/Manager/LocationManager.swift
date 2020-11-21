//
//  LocationManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 21/11/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import Foundation
import CoreLocation

//protocol LocationDelegate: class {
//    func updateCurrentLocaton(to location: CLLocation)
//}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    
    var lastLocation: CLLocation?
    var hasLocationAuthorization: Bool = false
    
    func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location Services are Disabled")
            return
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:                            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:                      hasLocationAuthorization = false
        case .authorizedAlways, .authorizedWhenInUse:   hasLocationAuthorization = true
        default: break
        }
    }
    
    func configureLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, newLocation != lastLocation else { return }
        lastLocation = newLocation
        // guard delegate and pass onto delegate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationServices()
    }
}
