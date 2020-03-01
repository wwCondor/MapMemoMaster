//
//  MMAnnotationMenuVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 01/03/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMAnnotationMenuVC: UIViewController {
    
    private var reminder: Reminder?
//
//
//    private var reminderTitle: String?
//    private var locationName: String?
//    private var locationAddress: String?
    
    private let containerView        = MMAlertContainerView()
    private let titleLabel           = MMTitleLabel(alignment: .center, text: "Title")
    private let locationNameLabel    = MMBodyLabel(alignment: .center, text: "Location Name")
    private let locationAddressLabel = MMBodyLabel(alignment: .center, text: "Address")
    private let navigationButton     = MMButton(title: "Navigate to location")
    private let shareButton          = MMButton(title: "Share Location")
    
    init(reminder: Reminder) {
        super.init(nibName: nil, bundle: nil)
        self.reminder = reminder
//        print("Reminder: \(reminder)")
//        self.reminderTitle    = reminder.title
//        self.locationName     = reminder.locationName
//        self.locationAddress  = reminder.locationAddress
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        layoutUI()
        configureLabels()
        configureButtons()
    }

    private func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, locationNameLabel, locationAddressLabel, navigationButton, shareButton)
        
        let padding: CGFloat = 20
        let labelHeight: CGFloat = 22
        let buttonHeight: CGFloat = 44
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 240),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: locationNameLabel.topAnchor),
            
            locationNameLabel.bottomAnchor.constraint(equalTo: locationAddressLabel.topAnchor),
            locationNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            locationNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            locationNameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            locationAddressLabel.bottomAnchor.constraint(equalTo: navigationButton.topAnchor, constant: -12),
            locationAddressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            locationAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            locationAddressLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            navigationButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -padding),
            navigationButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            navigationButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            navigationButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            shareButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            shareButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            shareButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            shareButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    private func configureLabels() {
        guard let reminder = reminder else { return }
        titleLabel.text           = reminder.title ?? "Unable to retrieve title"
        locationNameLabel.text    = reminder.locationName ?? "Unable to retieve location name"
        locationAddressLabel.text = reminder.locationAddress ?? "Unabel to retrieve address"
    }
    
    private func configureBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tap)
    }
    
    private func configureButtons() {
        navigationButton.addTarget(self, action: #selector(navigationButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc private func navigationButtonTapped(sender: MMButton) {
        print("Launch navigation")
    }
    
    @objc private func shareButtonTapped(sender: MMButton) {
        print("Launch share")
    }
}
