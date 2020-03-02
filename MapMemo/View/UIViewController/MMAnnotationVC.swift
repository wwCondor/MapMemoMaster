//
//  MMAnnotationVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 02/03/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

enum AnnotationMode { case pinLocation, myLocation }

class MMAnnotationVC: UIViewController {
    
    private var reminder: Reminder?
    private var modeSelected: AnnotationMode = .pinLocation
    
    private let containerView        = MMAlertContainerView()
    private let titleLabel           = MMTitleLabel(alignment: .center, text: "Title")
    private let locationNameLabel    = MMBodyLabel(alignment: .center, text: "Location Name")
    private let locationAddressLabel = MMBodyLabel(alignment: .center, text: "Address")
    private let dismissButton        = MMImageView(image: SFSymbols.close!, tintColor: .systemPink)
    private let actionButton         = MMButton(title: "Navigate to location")
    private let shareButton          = MMButton(title: "Share Location")
    
    init(mode: AnnotationMode, reminder: Reminder?) {
        super.init(nibName: nil, bundle: nil)
        self.reminder     = reminder
        self.modeSelected = mode
        configureLabels(for: mode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureTapGestures()
        layoutUI()
        configureButtons()
    }

    private func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, locationNameLabel, locationAddressLabel, dismissButton, actionButton, shareButton)
        
        let padding: CGFloat = 20
        let labelHeight: CGFloat = 22
        let buttonHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 260),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.bottomAnchor.constraint(equalTo: locationNameLabel.topAnchor),
            
            dismissButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            dismissButton.widthAnchor.constraint(equalToConstant: 22),
            dismissButton.heightAnchor.constraint(equalToConstant: 22),
            
            locationNameLabel.bottomAnchor.constraint(equalTo: locationAddressLabel.topAnchor),
            locationNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            locationNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            locationNameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            locationAddressLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            locationAddressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            locationAddressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            locationAddressLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            actionButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            shareButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            shareButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            shareButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            shareButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    private func configureLabels(for mode: AnnotationMode) {
        switch mode {
        case .pinLocation: configureLabelsForReminder()
        case .myLocation: configureLabelsForCurrentLocation()
        }
    }

    private func configureLabelsForReminder() {
        guard let reminder = reminder else { return }
        actionButton.setTitle("Navigate to location", for: .normal)
        titleLabel.text           = reminder.title ?? "Unable to retrieve title"
        locationNameLabel.text    = reminder.locationName ?? "Unable to retieve location name"
        locationAddressLabel.text = reminder.locationAddress ?? "Unabel to retrieve address"
    }
    
    private func configureLabelsForCurrentLocation() {
        actionButton.setTitle("Set Reminder", for: .normal)
        // get current location
        //
        
        // launch reminderVC with location preset when user taps action button
        
        titleLabel.text           = "Current Location"
        locationNameLabel.text    = "Location Name"
        locationAddressLabel.text = "Location address"
    }
    
    private func configureBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tap)
    }
    
    private func configureTapGestures() {
        dismissButton.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissButtonTapped))
        dismissButton.addGestureRecognizer(tap)
    }
    
    private func configureButtons() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backgroundTapped(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc private func dismissButtonTapped(sender: MMImageView) {
        dismiss(animated: true)
    }
    
    @objc private func actionButtonTapped(sender: MMButton) {
        switch modeSelected {
        case .pinLocation: print("Launch navigation")
        case .myLocation: print("Create reminder")
        }
        
        // MARK: Inform, dismiss and center map with a zoom
    }
    
    @objc private func shareButtonTapped(sender: MMButton) {
        print("Launch share")
    }
}
