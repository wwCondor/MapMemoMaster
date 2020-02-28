//
//  AppDelegate.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var locationManager: CLLocationManager?
    
    let managedObjectContext = CoreDataManager.shared.managedObjectContext
    let notificationsManager = NotificationAuthorizationManager.shared
    
    private let updateRemindersKey = Notification.Name(rawValue: Key.updateReminders)
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        locationManager = CLLocationManager()
        
        configureNotificationCenter()
        
        notificationsManager.requestAuthorization()
        
        return true
    }
    
    private func configureNotificationCenter() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
    }
        
    private func handleNotification(for region: CLRegion) {
        guard let reminder = managedObjectContext.fetchReminder(with: region.identifier, context: managedObjectContext) else {
            
            if UIApplication.shared.applicationState == .active {
                presentAlert(with: ReminderError.fetchReminder.localizedDescription)
            }
            return
        }
        
        if UIApplication.shared.applicationState == .active {
            let prefix   = reminder.triggerOnEntry ? "Arrived at" : "Leaving"
            let location = String(describing: reminder.locationName)
            let message  = String(describing: reminder.message)
            presentAlert(with: "\(prefix) \(location): \(message))")
        }
        
        if reminder.isRepeating == false { setStatusInactive(for: reminder) }
        
        UIApplication.shared.applicationIconBadgeNumber += 1
    }
    
    private func presentAlert(with description: String) {
        let viewController = UIApplication.shared.windows.first?.rootViewController
        
        if let viewController = viewController {
            viewController.presentAlert(description: description, viewController: viewController)
        }
    }
    
    private func setStatusInactive(for reminder: Reminder) {
        reminder.isActive = false
        managedObjectContext.saveChanges()
        NotificationCenter.default.post(name: updateRemindersKey, object: nil)
        print("\(String(describing: reminder.title)) is active: \(reminder.isActive)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        handleNotification(for: region)
    }
    
    // Called when region is exited
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        handleNotification(for: region)
    }
}
