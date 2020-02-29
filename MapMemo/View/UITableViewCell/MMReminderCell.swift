//
//  MMReminderCell.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMReminderCell: UITableViewCell {
    
    static let identifier = "reminderCellId"
    
    private let contentBackgroundView     = MMContentView(borderColor: .systemPink, cornerRadius: 5)
    private let triggerStatusImageView    = MMImageView(image: SFSymbols.enterTrigger!)
    private let reminderStatusImageView   = MMImageView(image: SFSymbols.notificationOn!)
    private let repeatStatusImageView     = MMImageView(image: SFSymbols.isRepeating!)
    
    let titleLabel        = MMTitleLabel(alignment: .left, text: "Reminder title")
//    let locationLabel     = MMSecondaryTitleLabel(alignment: .left, text: "Location Name")
    let addressLabel      = MMSecondaryTitleLabel(alignment: .left, text: "Address")
    let messageLabel      = MMSecondaryTitleLabel(alignment: .left, text: "A short message")
    let activationSwitch  = MMSwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureCellContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = .clear
    }
    
    private func configureCellContent() {
        addSubviews(contentBackgroundView, triggerStatusImageView, reminderStatusImageView, repeatStatusImageView, activationSwitch)
        addSubviews(titleLabel, addressLabel, messageLabel)
        
        triggerStatusImageView.transform  = CGAffineTransform(rotationAngle: -.pi/2)
        
        let padding: CGFloat              = 10
        let largePadding: CGFloat         = 20
        let iconSize: CGFloat             = 25
        let labelHeight: CGFloat          = 24
        let secondaryLabelHeight: CGFloat = 20
        
        NSLayoutConstraint.activate([
            contentBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: padding/2),
            contentBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            contentBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            contentBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding/2),
            
            titleLabel.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
//            titleLabel.bottomAnchor.constraint(equalTo: addressLabel.topAnchor, constant: -padding),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            messageLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            messageLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -3),
            messageLabel.heightAnchor.constraint(equalToConstant: secondaryLabelHeight),
            
            addressLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
//            addressLabel.centerYAnchor.constraint(equalTo: contentBackgroundView.centerYAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            addressLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -padding),
            addressLabel.heightAnchor.constraint(equalToConstant: secondaryLabelHeight),
            
//            reminderStatusImageView.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: padding),
//            reminderStatusImageView.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -20),
//            reminderStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
//            reminderStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
//            repeatStatusImageView.centerYAnchor.constraint(equalTo: reminderStatusImageView.centerYAnchor),
//            repeatStatusImageView.trailingAnchor.constraint(equalTo: reminderStatusImageView.leadingAnchor, constant: -5),
//            repeatStatusImageView.heightAnchor.constraint(equalToConstant: 22),
//            repeatStatusImageView.widthAnchor.constraint(equalToConstant: 22),
            
            triggerStatusImageView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -padding),
            triggerStatusImageView.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            triggerStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
            triggerStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            reminderStatusImageView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -padding),
            reminderStatusImageView.leadingAnchor.constraint(equalTo: triggerStatusImageView.trailingAnchor, constant: padding),
            reminderStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
            reminderStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            repeatStatusImageView.centerYAnchor.constraint(equalTo: reminderStatusImageView.centerYAnchor),
            repeatStatusImageView.leadingAnchor.constraint(equalTo: reminderStatusImageView.trailingAnchor, constant: padding),
            repeatStatusImageView.heightAnchor.constraint(equalToConstant: 18),
            repeatStatusImageView.widthAnchor.constraint(equalToConstant: 18),
            
//            messageLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: padding),
//            messageLabel.leadingAnchor.constraint(equalTo: triggerStatusImageView.trailingAnchor),
//            messageLabel.trailingAnchor.constraint(equalTo: activationSwitch.leadingAnchor),
//            messageLabel.heightAnchor.constraint(equalToConstant: secondaryLabelHeight),
            
            activationSwitch.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 15),
            activationSwitch.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -20),
        ])
    }
    
    func set(reminder: Reminder) {
//        guard let title = reminder.title, let locationName = reminder.locationName else { return }
        guard let locationName = reminder.locationName, let address = reminder.locationAddress else { return }
        
//        titleLabel.text                  = "\(title) @ \(locationName)"
        titleLabel.text                  = reminder.title
        addressLabel.text                = "\(locationName) \(address)"   //reminder.locationAddress
        messageLabel.text                = reminder.message
        
        reminderStatusImageView.image    = reminder.isActive ? SFSymbols.notificationOn : SFSymbols.notificationOff
        triggerStatusImageView.image     = reminder.triggerOnEntry ? SFSymbols.enterTrigger : SFSymbols.exitTrigger
        repeatStatusImageView.isHidden   = reminder.isRepeating ? false : true
        
        contentBackgroundView.backgroundColor = reminder.isActive ? .systemPink : .systemGray4
        
        let switchStatus: Bool = reminder.isActive ? true : false
        self.activationSwitch.setOn(switchStatus, animated: false)
    }
}
