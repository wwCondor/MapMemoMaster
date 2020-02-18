//
//  AppDelegate.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter!
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        locationManager = CLLocationManager()
////        locationManager!.delegate = self
//        notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.delegate = self
//
//        let notificationsManager = NotificationManager.shared
//        notificationsManager.requestNotificationAuthorization()
//
//
//
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = UINavigationController(rootViewController: MainController())
        
        return true
    }
    
    func handleNotification(for region: CLRegion) {
        guard let reminder = CoreDataManager.shared.managedObjectContext.fetchReminder(with: region.identifier, context: CoreDataManager.shared.managedObjectContext) else {
            // Check for reminder
            if UIApplication.shared.applicationState == .active {
                presentAlert(description: ReminderError.fetchReminder.localizedDescription)
            }
            return
        }
    
        if UIApplication.shared.applicationState == .active {
            let triggerCondition = reminder.triggerWhenEntering ? "Arrived at" : "Leaving"
            presentAlert(description: "\(triggerCondition) \(String(describing: reminder.locationName)): \(String(describing: reminder.message))")
        }
        // Disable after trigger when user selected isRepeating == false
        if reminder.isRepeating != true {
            reminder.isActive = false
            CoreDataManager.shared.managedObjectContext.saveChanges()
            print("\(String(describing: reminder.title)) is active: \(reminder.isActive)")
        }
        UIApplication.shared.applicationIconBadgeNumber += 1
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // This sets the badge number to 0
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}


extension AppDelegate: CLLocationManagerDelegate {
    // Called when region is entered
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        handleNotification(for: region)
    }
    
    // Called when region is exited
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        handleNotification(for: region)
    }
}

// MARK: Notification Center Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Enables notifications even if application is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    // MARK: Extra Feature?
    // When user taps notification we could direct user to center of region
    // Idea: If user agrees we could have another "compass" that instead of pointing north points to location center
    // This enables a response to the notification
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let request = response.notification.request
//
//        guard let reminder = managedObjectContext.fetchReminder(with: request.identifier, context: managedObjectContext) else {
//            if UIApplication.shared.applicationState == .active {
//                presentAlert(description: ReminderError.fetchReminder.localizedDescription)
//            }
//            print("This other thing did not work")
//            completionHandler()
//            return
//        }
//
//        handleNotification(for: reminder)
//
//        completionHandler()
//    }
}

extension AppDelegate {
    func presentAlert(description: String) {
        let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert)
        let confirmation = UIAlertAction(title: "OK", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmation)

        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens
        if let window = window {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
