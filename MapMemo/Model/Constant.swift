//
//  Constant.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

struct Constant {
    static let buttonBarHeight: CGFloat             = 60    // Buttons/buttonbar height
    static let textXInset: CGFloat                  = 10    // ActiveReminders: textField x inset
    static let textYInset: CGFloat                  = 5     // ActiveReminders: radiusInfoField y inset
    static let borderWidth: CGFloat                 = 2
    static let inputFieldSize: CGFloat              = 50    // ReminderController input field height
    static let activeReminderCellSize: CGFloat      = 90    // ActiveRemindersController cell height
    static let activeReminderContentHeight: CGFloat = Constant.activeReminderCellSize/3
    static let activeReminderOffset: CGFloat        = Constant.activeReminderCellSize/4
    static let offset: CGFloat                      = Constant.inputFieldSize/4
    
    
    static let compassSize: CGFloat                 = Constant.buttonBarHeight
    static let compassCornerRadius: CGFloat         = Constant.buttonBarHeight/2
    
    static let cellPadding: CGFloat                 = Constant.inputFieldSize/8
    static let arrowOffset: CGFloat                 = 13
}

struct Key {
    static let updateReminderNotification = "updateReminders"
}
