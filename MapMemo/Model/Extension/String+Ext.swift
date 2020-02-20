
//
//  String+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import Foundation

extension String {
    /// Convert String to Float
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    /// String to Double
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    /// Bool indicating  whether a string contains any characters
    public var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
