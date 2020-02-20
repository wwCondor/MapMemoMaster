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

    private let activationSwitch        = MMSwitch()
    private let contentBackgroundView   = MMContentView(borderColor: .systemPink, cornerRadius: 5)
    private let triggerStatusImageView  = MMImageView(image: SFSymbols.enterTrigger!)
    private let repeatStatusImageView   = MMImageView(image: SFSymbols.notificationOn!)
    
    let titleLabel      = MMTitleLabel(alignment: .left, text: "Reminder title")
    let locationLabel   = MMTitleLabel(alignment: .left, text: "Location")
    let messageLabel    = MMTitleLabel(alignment: .left, text: "A short message")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureCellContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = .systemBackground
    }
    
    private func configureCellContent() {
        addSubviews(contentBackgroundView, triggerStatusImageView, repeatStatusImageView, activationSwitch)
        addSubviews(titleLabel, locationLabel, messageLabel)
        
        triggerStatusImageView.transform = CGAffineTransform(rotationAngle: -.pi/2)
        
        let padding: CGFloat = 10
        let iconSize: CGFloat = 31
        let labelHeight: CGFloat = 24
        
        NSLayoutConstraint.activate([
            contentBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: padding/2),
            contentBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            contentBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            contentBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding/2),
            
            titleLabel.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),//, constant: -5),
            messageLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -3),
            messageLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            locationLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),//, constant: -5),
            locationLabel.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -3),
            locationLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            repeatStatusImageView.topAnchor.constraint(equalTo: contentBackgroundView.topAnchor, constant: padding),
            repeatStatusImageView.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -20),
            repeatStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
            repeatStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            triggerStatusImageView.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -padding),
            triggerStatusImageView.leadingAnchor.constraint(equalTo: contentBackgroundView.leadingAnchor, constant: 20),
            triggerStatusImageView.heightAnchor.constraint(equalToConstant: iconSize),
            triggerStatusImageView.widthAnchor.constraint(equalToConstant: iconSize),
            
            activationSwitch.bottomAnchor.constraint(equalTo: contentBackgroundView.bottomAnchor, constant: -padding),
            activationSwitch.trailingAnchor.constraint(equalTo: contentBackgroundView.trailingAnchor, constant: -20),
        ])
    }
    
    @objc private func switchToggled() {
        print("Toggled")
    }
    
    func set(reminder: Reminder) {
        titleLabel.text               = reminder.title
        messageLabel.text             = reminder.message
        locationLabel.text            = reminder.locationName
        repeatStatusImageView.image   = reminder.isRepeating ? SFSymbols.notificationOn : SFSymbols.notificationOff
        triggerStatusImageView.image  = reminder.triggerOnEntry ? SFSymbols.enterTrigger : SFSymbols.exitTrigger
        activationSwitch.isOn         = reminder.isActive ? true : false
    }
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//
//    }

}
