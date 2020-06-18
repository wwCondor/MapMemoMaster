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
//    case locationInfoNotFound
    case noResults
    case failedFetch
    case addNotificationFailed
    case notificationAuthorizationDenied
    case locationAuthorizationDenied
    case locationServicesDisabled
    case unableToObtainLocation
    case requestFailed
    case unableToUpdateUI
    case noCoordinate
}

extension MMError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .noConnection:                     return "Seems there is no internet connection, try again later."
//        case .locationInfoNotFound:             return "Unable to obtain information on current location, please try again."
        case .noResults:                        return "Unable to find search results."
        case .failedFetch:                      return "Unable to retrieve reminders from memory."
        case .addNotificationFailed:            return "An error occured creating the notification request."
        case .notificationAuthorizationDenied:  return "Notification Authorization denied. Authorization preferences can be changed in settings."
        case .locationAuthorizationDenied:      return "Location Authorization denied or restrricted. You can change authorization preferences in settings."
        case .locationServicesDisabled:         return "Location services are disabled. Switch on location services in phone settings. Go to settings now?"
        case .unableToObtainLocation:           return "Unable to obtain a location information for the selected location. Pleease try again."
        case .requestFailed:                    return "Unable to create notification request for reminder."
        case .unableToUpdateUI:                 return "Unable to retrieve reminder info to update the UI"
        case .noCoordinate:                     return "Unable to retieve coordinate for location"
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
