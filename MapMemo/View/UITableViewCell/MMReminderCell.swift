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
    let locationLabel     = MMSecondaryTitleLabel(alignment: .left, text: "Location")
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
        addSubviews(titleLabel, locationLabel, messageLabel)
        
        triggerStatusImageView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        let padding: CGFloat = 10
        let iconSize: CGFloat = 31
        let labelHeight: CGFloat = 24
        let secondaryLabelHeight: CGFloat = 20
        
        NSLayoutConstraint.activate([
            contentBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: padding/2),
            contentBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            contentBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            contentBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding/2),
            
            titleLabel.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -3),
            messageLabel.heightAnchor.constraint(equalToConstant: secondaryLabelHeight),
            
            locationLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -3),
            locationLabel.heightAnchor.constraint(equalToConstant: secondaryLabelHeight),
            
            reminderStatusImageView.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: padding),
            reminderStatusImageView.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -20),
            reminderStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
            reminderStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            repeatStatusImageView.centerYAnchor.constraint(equalTo: reminderStatusImageView.centerYAnchor),
            repeatStatusImageView.trailingAnchor.constraint(equalTo: reminderStatusImageView.leadingAnchor, constant: -5),
            repeatStatusImageView.heightAnchor.constraint(equalToConstant: 22),
            repeatStatusImageView.widthAnchor.constraint(equalToConstant: 22),
            
            triggerStatusImageView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -padding),
            triggerStatusImageView.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            triggerStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
            triggerStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            activationSwitch.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -12),
            activationSwitch.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -20),
        ])
    }
    
    func set(reminder: Reminder) {
        titleLabel.text                  = reminder.title
        messageLabel.text                = reminder.message
        locationLabel.text               = reminder.locationName
        
        reminderStatusImageView.image    = reminder.isActive ? SFSymbols.notificationOn : SFSymbols.notificationOff
        triggerStatusImageView.image     = reminder.triggerOnEntry ? SFSymbols.enterTrigger : SFSymbols.exitTrigger
        repeatStatusImageView.isHidden   = reminder.isRepeating ? false : true
        
        contentBackgroundView.backgroundColor = reminder.isActive ? .systemPink : .systemGray4
        
        let switchStatus: Bool = reminder.isActive ? true : false
        self.activationSwitch.setOn(switchStatus, animated: false)
    }
}
