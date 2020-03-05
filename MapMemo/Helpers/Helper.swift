//
//  Helper.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 04/03/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import Foundation
import MapKit

struct Helper {
    static func createSubtitle(for placemark: MKPlacemark) -> String {
        var subtitle: String          = ""
        var addressComponent: String  = ""
        var cityCompent: String       = ""
        var countryComponent: String  = ""
        
        if let streetAddress = placemark.thoroughfare, let streetNumber = placemark.subThoroughfare {
            addressComponent = "\(streetAddress) \(streetNumber)"
        } else if let streetAddress = placemark.thoroughfare {
            addressComponent = "\(streetAddress)"
        } else {
            addressComponent = ""
        }
        
        if let city = placemark.locality {
            cityCompent = "in \(city)"
        } else {
            cityCompent = ""
        }
        
        if let isoCountryCode = placemark.isoCountryCode {
            countryComponent = "(\(isoCountryCode))"
        } else {
            countryComponent = ""
        }
        
        subtitle = "\(addressComponent) \(cityCompent) \(countryComponent)"
        
        return subtitle
    }
    
//    static func getInformation(for location: CLLocationCoordinate2D) -> [String] {
//        let geoCoder  = CLGeocoder()
//        let latitude  = location.latitude
//        let longitude = location.longitude
//        
//        var titleSubtitle: [String] = []
////        var title     = ""
////        var subtitle  = ""
//
//        geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemarks, error) in
//            guard error == nil else { return }
//            guard let placemark         = placemarks?.last else { return }
//            guard let name              = placemark.name else { return }
//            guard let streetAddress     = placemark.thoroughfare, let streetNumber = placemark.subThoroughfare else { return }
//            guard let city              = placemark.locality else { return }
//            guard let isoCountryCode    = placemark.isoCountryCode else { return }
//            
//            titleSubtitle.append(name)
//            
//            if "\(name)" == "\(streetAddress) \(streetNumber)" {
//                titleSubtitle.append("\(city) (\(isoCountryCode))")
//            } else {
//                titleSubtitle.append("\(streetAddress) \(streetNumber), \(city) (\(isoCountryCode))")
//            }
//        }
//        
//        return titleSubtitle
//    }
}
