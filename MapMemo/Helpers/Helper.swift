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
}
