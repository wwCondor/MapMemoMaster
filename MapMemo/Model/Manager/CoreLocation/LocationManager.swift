//
//  LocationManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 24/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
//import UserNotifications

//class LocationManager: NSObject {
//    
//    let coreDataManagar = CoreDataManager.shared
//
//    let manager = CLLocationManager()
////    var locationManager: CLLocationManager?
////    var notificationsCenter: UNUserNotificationCenter!
//
//    override init() {
//        super.init()
//        configure()
//    }
//
//    private func configure() {
////        locationManager = CLLocationManager()
////        notificationsCenter = UNUserNotificationCenter.current()
//    }
//
//    private func handleNotification(for region: CLRegion) {
//        let window = UIApplication.shared.windows.first!.rootViewController
//
//        if let window = window {
//            guard let reminder = coreDataManagar.managedObjectContext.fetchReminder(with: region.identifier, context: coreDataManagar.managedObjectContext) else {
//                if UIApplication.shared.applicationState == .active {
//                    window.presentAlert(description: "", viewController: window)
//                }
//                return
//            }
//
//            if UIApplication.shared.applicationState == .active {
//                let triggerCondition = reminder.triggerOnEntry ? "Arrived at" : "Leaving"
//                guard let locationName = reminder.locationName else { return }
//                guard let message = reminder.message else { return }
//                window.presentAlert(description: "\(triggerCondition) \(locationName): \(message)", viewController: window)
//            }
//
//            if reminder.isRepeating != true {
//                reminder.isActive = false
//                coreDataManagar.managedObjectContext.saveChanges()
//            }
//
//            UIApplication.shared.applicationIconBadgeNumber += 1
//        }
//    }
//
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber = 0
//    }
//}
//
//extension LocationManager: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        handleNotification(for: region)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        handleNotification(for: region)
//    }
//}
