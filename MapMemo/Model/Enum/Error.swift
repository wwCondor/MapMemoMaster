//
//  Error.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 10/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

enum MMError: Error {
    case noConnection
    case noLocation
    case noResults
    case failedFetch
    case addNotificationFailed
    
    case notificationAuthorizationDenied
    case locationAuthorizationDenied
    case locationServicesDisabled
}

extension MMError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .noConnection:                    return "There is no internet connection."
        case .noLocation:                      return "An error occured finding the location for the current selection, please try again."
        case .noResults:                       return "Unable to find search results"
        case .failedFetch:                     return "Unable to retrieve reminders from memory"
        case .addNotificationFailed:           return "An error occured creating the notification request"
            
        case .notificationAuthorizationDenied: return "Notification Authorization denied. You can change authorization preferences in settings."
        case .locationAuthorizationDenied:     return "Location Authorization denied or restrricted. You can change authorization preferences in settings."
        case .locationServicesDisabled:        return "Woops! It seems location services are disabled. You can switch on location services in your phone settings under Privacy. Would you like to go to settings to enable location services?"
            
        }
    }
}

//enum NotificationError: Error {
//    case alertSettingNotEnabled
//}
//
//extension NotificationError: LocalizedError {
//    public var localizedDescription: String {
//        switch self {
//        case .alertSettingNotEnabled:           return "Notification alerts disabled. This can be changed in phone settings"
//        }
//    }
//}

enum MMReminderError: Error {
    case reminderNil
    case missingTitle
    case missingMessage 
    case missingLatitude
    case missingLongitude
    case missingLocationName
    case missingLocationAddress
    case unableToObtainLocation
    case maxRemindersReached
    case titleIsDuplicate
}

extension MMReminderError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .reminderNil:                  return "An error occured retrieving the reminder"
        case .missingTitle:                 return "Woops! It seems you forgot to add a title to your reminder"
        case .missingMessage:               return "Woops! It seems you forgot to add a message to your reminder"
        case .missingLatitude:              return "Woops! It seems you forgot to enter a value for the latitude"
        case .missingLongitude:             return "Woops! It seems you forgot to enter a value for the longitude"
        case .missingLocationName:          return "Woops! It seems no name could be found for the selected location"
        case .missingLocationAddress:       return "Woops! It seems no address could be found for the selected location"
        case .unableToObtainLocation:       return "Unable to obtain a location name for the coordinates you entered"
        case .maxRemindersReached:          return "Maximum active reminders (20) reached. You need to delete a reminder first"
        case .titleIsDuplicate:             return "Unable to save reminder. Reminder title already exists."
        }
    }
}


