//
//  NotificationAuthorizationManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 24/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationAuthorizationManager: NSObject {
    
    static let shared = NotificationAuthorizationManager()
    
    let notificationsCenter = UNUserNotificationCenter.current()
    
    var hasAuthorization: Bool = false
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        
        notificationsCenter.requestAuthorization(options: options) { (authorizationGranted, error) in
            switch authorizationGranted {
            case true: self.hasAuthorization = true
            case false: self.hasAuthorization = false
            }
        }
    }
    
    func checkNotificationAuthorization() {
        notificationsCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.hasAuthorization = false
            } else {
                self.hasAuthorization = true
            }
        }
    }
    

}
