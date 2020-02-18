//
//  FloatingPoint+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import Foundation

extension FloatingPoint {
    // Converts to radians. Used for compass image rotation
    var degreesToRadians: Self { return self * .pi / 180 }
}
