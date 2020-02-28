//
//  MMAlertVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 28/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMAlertVC: UIViewController {
    
    private var alertTitle: String?
    private var alertMessage: String?
    private var alertButtonTitle: String?
    
    private let containerView   = MMAlertContainerView()
    private let titleLabel      = MMTitleLabel(alignment: .center, text: "Something went wrong")
    private let messageLabel    = MMBodyLabel(alignment: .center, text: "Unable to complete request")
    private let actionButton    = MMButton(title: "OK")
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle       = title
        self.alertMessage     = message
        self.alertButtonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)

        layoutUI()
        configureLabels()
        configureButton()
    }
    
    private func layoutUI() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, messageLabel, actionButton)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func configureLabels() {
        titleLabel.text = self.alertTitle ?? "Something went wrong"
        messageLabel.text = self.alertMessage ?? "Unable to complete request"
        messageLabel.numberOfLines = 4
    }
    
    private func configureButton() {
        actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}
