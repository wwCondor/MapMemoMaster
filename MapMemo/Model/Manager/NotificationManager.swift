//
//  NotificationAuthorizationManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 24/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

class NotificationManager: NSObject {
    
    static let shared = NotificationManager()
    
    private let managedObjectContext = CoreDataManager.shared.managedObjectContext
    private let updateRemindersKey   = Notification.Name(rawValue: Key.updateReminders)
    private let notificationsCenter  = UNUserNotificationCenter.current()
    
    var hasAuthorization: Bool = false
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        
        notificationsCenter.requestAuthorization(options: options) { (authorizationGranted, error) in
            switch authorizationGranted {
            case true:  self.hasAuthorization = true
            case false: self.hasAuthorization = false
            }
        }
    }
    
    func handleNotification(for region: CLRegion) {
        guard let reminder = managedObjectContext.fetchReminder(with: region.identifier, context: managedObjectContext) else {
            
            if UIApplication.shared.applicationState == .active {
                presentAlert(with: "Reminder Fetch Error", description: MMError.failedFetch.localizedDescription)
            }
            return
        }
        
        if UIApplication.shared.applicationState == .active {
            let prefix   = reminder.triggerOnEntry ? "Arrived at" : "Leaving"
            let location = String(describing: reminder.locationName)
            let message  = String(describing: reminder.message)
            presentAlert(with: "\(prefix) \(location)", description: message)
        }
        
        if reminder.isRepeating != true {
            setStatusInactive(for: reminder)
        }
        
        UIApplication.shared.applicationIconBadgeNumber += 1
    }
    
    private func presentAlert(with title: String, description: String) {
        let viewController = UIApplication.shared.windows.first?.rootViewController
        
        if let viewController = viewController {
            viewController.presentMMAlertOnMainThread(title: title, message: description, buttonTitle: "OK")
        }
    }
    
    private func setStatusInactive(for reminder: Reminder) {
        reminder.isActive = false
        managedObjectContext.saveChanges()
        NotificationCenter.default.post(name: updateRemindersKey, object: nil)
        print("\(String(describing: reminder.title)) is active: \(reminder.isActive)")
    }
    
//    func checkNotificationAuthorization() {
//        notificationsCenter.getNotificationSettings { (settings) in
//            if settings.authorizationStatus != .authorized {
//                self.hasAuthorization = false
//            } else {
//                self.hasAuthorization = true
//            }
//        }
//    }
}
