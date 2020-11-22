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
        case .noResults:                        return "Unable to find search results."
        case .failedFetch:                      return "Unable to retrieve reminders from memory."
        case .addNotificationFailed:            return "An error occured creating the notification request."
        case .notificationAuthorizationDenied:  return "Notification Authorization denied. Authorization preferences can be changed in settings."
        case .locationAuthorizationDenied:      return "Location Authorization denied or restrricted. You can change authorization preferences in settings."
        case .locationServicesDisabled:         return "Location services are disabled. Would you like you switch on location services in phone settings now?"
        case .unableToObtainLocation:           return "Unable to obtain a location information for the selected location. Pleease try again."
        case .requestFailed:                    return "Unable to create notification request for reminder."
        case .unableToUpdateUI:                 return "Unable to retrieve reminder info to update the UI"
        case .noCoordinate:                     return "Unable to retieve coordinate for location"
        }
    }
}

enum MMReminderError: Error {
    case reminderNil
    case missingMessage 
    case missingLatitude
    case missingLongitude
//    case missingLocationName
    case missingLocationAddress
    case unableToObtainLocation
    case maxRemindersReached
    case titleIsDuplicate
    case noLocation
}

extension MMReminderError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .reminderNil:                  return "An error occured retrieving the reminder"
        case .missingMessage:               return "Woops! It seems you forgot to add a message to your reminder"
        case .missingLatitude:              return "An error occured finding the latitude for the selected location"
        case .missingLongitude:             return "An error occured finding the longitude for the selected location"
//        case .missingLocationName:          return "Woops! It seems no name could be found for the selected location"
        case .missingLocationAddress:       return "Woops! It seems no address could be found for the selected location"
        case .unableToObtainLocation:       return "Unable to obtain a location name for the selected coordinates"
        case .maxRemindersReached:          return "Maximum active reminders (20) reached. You need to delete a reminder first"
        case .titleIsDuplicate:             return "Unable to save reminder. A reminder with this title already exists."
        case .noLocation:                   return "Use Search Location to add a location to the reminder."
        }
    }
}
