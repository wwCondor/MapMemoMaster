//
//  MMAnnotationVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 02/03/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreLocation

enum AnnotationMode { case pinLocation, myLocation }

protocol AnnotationDelegate: class {
    func userTappedShareButton()
    func userTappedNavigationButton()
    func userTappedAddReminderButton()
}

class MMAnnotationVC: UIViewController {
    
    weak var delegate: AnnotationDelegate!
    
    var locationNameInfo: String?
    var locationAddressInfo: String?
    var modeSelected: AnnotationMode = .pinLocation
    var reminder: Reminder?
    
    private let containerView        = MMAlertContainerView()
    private let locationNameLabel    = MMBodyLabel(alignment: .center, text: "Location Name")
    private let locationAddressLabel = MMBodyLabel(alignment: .center, text: "Address")
    private let dismissButton        = MMImageView(image: SFSymbols.close!, tintColor: .systemPink)
    private let actionButton         = MMButton(title: "Navigate to location")
    private let shareButton          = MMButton(title: "Share Location")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureTapGestures()
        layoutUI()
        configureButtons()
        configureLabels(for: modeSelected)
    }

    private func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubviews(locationNameLabel, locationAddressLabel, dismissButton, actionButton, shareButton)
        
        let padding: CGFloat = 20
        let labelHeight: CGFloat = 22
        let buttonHeight: CGFloat = 50
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 244),
            
            dismissButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            dismissButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            dismissButton.widthAnchor.constraint(equalToConstant: 22),
            dismissButton.heightAnchor.constraint(equalToConstant: 22),
            
            locationNameLabel.bottomAnchor.constraint(equalTo: locationAddressLabel.topAnchor),
            locationNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            locationNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            locationNameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            locationAddressLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -padding),
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
        locationNameLabel.text    = reminder.locationName ?? "Unable to retieve location title"
        locationAddressLabel.text = reminder.locationAddress ?? "Unabel to retrieve location address"
    }
    
    private func configureLabelsForCurrentLocation() {
        actionButton.setTitle("Set Reminder", for: .normal)
        locationNameLabel.text    = locationNameInfo ?? "Unable to retrieve location info. Please try again."
        locationAddressLabel.text = locationAddressInfo ?? ""
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
        case .pinLocation:
            delegate.userTappedNavigationButton()
        case .myLocation:
            dismiss(animated: true)
            delegate.userTappedAddReminderButton()
        }
        
        // MARK: Inform, dismiss and center map with a zoom
    }
    
    @objc private func shareButtonTapped(sender: MMButton) {
        delegate.userTappedShareButton()
    }
}
