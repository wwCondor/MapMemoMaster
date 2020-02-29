//
//  UserDefaults+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 29/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

//enum PersistenceManager {
//    static private let defaults = UserDefaults.standard
//}

extension UserDefaults {
    
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
    }
    
    func set(_ color: UIColor?, forKey key: String) {
        guard let color = color else { return }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("Color data not saved: \(error.localizedDescription)")
        }
    }
}
