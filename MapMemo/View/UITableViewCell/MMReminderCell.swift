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
    
    private let contentBackgroundView       = MMContentView(borderColor: .systemPink, cornerRadius: 5)
    private let triggerConditionImageView   = MMImageView(image: SFSymbols.enterTrigger!, tintColor: .white)
    private let reminderStatusImageView     = MMImageView(image: SFSymbols.notificationOn!, tintColor: .white)
    
    let messageLabel      = MMTitleLabel(alignment: .left, text: "A short message")
    let titleLabel        = MMSecondaryTitleLabel(alignment: .left, text: "Reminder title")
    let subtitleLabel     = MMSecondaryTitleLabel(alignment: .left, text: "Address")
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
        addSubviews(contentBackgroundView, triggerConditionImageView, reminderStatusImageView, activationSwitch)
        addSubviews(titleLabel, subtitleLabel, messageLabel)
        
        triggerConditionImageView.transform  = CGAffineTransform(rotationAngle: -.pi/2)
        
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
            
            messageLabel.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 15),
            messageLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            messageLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -3),
            messageLabel.heightAnchor.constraint(equalToConstant: secondaryLabelHeight),
            
            titleLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            titleLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -padding),
            subtitleLabel.heightAnchor.constraint(equalToConstant: secondaryLabelHeight),
            
            triggerConditionImageView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -padding),
            triggerConditionImageView.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: largePadding),
            triggerConditionImageView.heightAnchor.constraint(equalToConstant: iconSize),
            triggerConditionImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            reminderStatusImageView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -padding),
            reminderStatusImageView.leadingAnchor.constraint(equalTo: triggerConditionImageView.trailingAnchor, constant: padding),
            reminderStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
            reminderStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            activationSwitch.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: 15),
            activationSwitch.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -20),
        ])
    }
    
    func set(reminder: Reminder) {
        titleLabel.text                         = reminder.locationName
        subtitleLabel.text                      = reminder.locationAddress
        messageLabel.text                       = reminder.message
        reminderStatusImageView.image           = reminder.isActive ? SFSymbols.notificationOn : SFSymbols.notificationOff
        triggerConditionImageView.image            = reminder.triggerOnEntry ? SFSymbols.enterTrigger : SFSymbols.exitTrigger
        contentBackgroundView.backgroundColor   = reminder.isActive ? .systemPink : .systemGray4
        
        let switchStatus: Bool = reminder.isActive ? true : false
        self.activationSwitch.setOn(switchStatus, animated: false)
    }
}
