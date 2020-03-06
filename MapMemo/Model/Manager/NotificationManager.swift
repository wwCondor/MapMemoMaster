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

protocol NotificationManagerDelegate: class {
    func informLocationManager(for region: CLCircularRegion)
}

class NotificationManager: NSObject {
    
    weak var delegate: NotificationManagerDelegate!
    
    static let shared = NotificationManager()
    
    private let managedObjectContext = CoreDataManager.shared.managedObjectContext
    private let updateRemindersKey   = Notification.Name(rawValue: Key.updateReminders)
    let notificationCenter  = UNUserNotificationCenter.current()
    
    var hasAuthorization: Bool = false
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        
        notificationCenter.requestAuthorization(options: options) { (authorizationGranted, error) in
            switch authorizationGranted {
            case true:  self.hasAuthorization = true
            case false: self.hasAuthorization = false
            }
        }
    }
    
    // MARK: Added
    func addNotificationRequest(for reminder: Reminder) {
        if let identifier = reminder.identifier,  let locationName = reminder.locationName,  let message = reminder.message {
            
            let coordinate      = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
            let trigger         = createTrigger(for: reminder, with: identifier, at: coordinate)
            let content         = UNMutableNotificationContent()
            let messagePrefix   = reminder.triggerOnEntry ? "Arrived at" : "Leaving"
            content.title       = identifier
            content.body        = "\(messagePrefix) \(locationName): \(message)"
            content.sound       = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            notificationCenter.add(request)
        } else {
            presentAlert(title: "Request Failed", message: MMError.requestFailed.localizedDescription)
        }
    }
    
    // MARK: Added
    private func createTrigger(for reminder: Reminder, with identifier: String, at coordinate: CLLocationCoordinate2D) -> UNLocationNotificationTrigger {
        let region = CLCircularRegion(center: coordinate, radius: reminder.bubbleRadius, identifier: identifier)
        delegate.informLocationManager(for: region)
        
        switch reminder.triggerOnEntry {
        case true:
            region.notifyOnEntry = true // Should be enough to set false only since true is default - Test
            region.notifyOnExit  = false
        case false:
            region.notifyOnEntry = false
            region.notifyOnExit  = true
        }
        return UNLocationNotificationTrigger(region: region, repeats: reminder.isRepeating)
    }
    
    func handleNotification(for region: CLRegion) {
        guard let reminder = managedObjectContext.fetchReminder(with: region.identifier, context: managedObjectContext) else {
            
            if UIApplication.shared.applicationState == .active {
                presentAlert(title: "Reminder Fetch Error", message: MMError.failedFetch.localizedDescription)
            }
            return
        }
        
        if UIApplication.shared.applicationState == .active {
            let prefix       = reminder.triggerOnEntry ? "Arrived at" : "Leaving"
            let locationName = String(describing: reminder.locationName)
            let message      = String(describing: reminder.message)
            presentAlert(title: "\(prefix) \(locationName)", message: message)
        }
        
        if reminder.isRepeating != true {
            setStatusInactive(for: reminder)
        }
        
        UIApplication.shared.applicationIconBadgeNumber += 1
    }
    
    private func presentAlert(title: String, message: String) {
        let viewController = UIApplication.shared.windows.first?.rootViewController
        if let viewController = viewController {
            viewController.presentMMAlertOnMainThread(title: title, message: description, buttonTitle: "OK")
        }
    }
    
    private func setStatusInactive(for reminder: Reminder) {
        guard let identifier = reminder.identifier else { return }
        reminder.isActive = false
        managedObjectContext.saveChanges()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        NotificationCenter.default.post(name: updateRemindersKey, object: nil)
        print("Reminder: \(String(describing: reminder.locationName))) is active: \(reminder.isActive)")
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
