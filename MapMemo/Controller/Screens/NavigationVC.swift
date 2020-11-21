//
//  NavigationVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 21/11/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import Foundation
import UIKit

class NavigationViewcontroller: UIViewController {
    
    var reminder: Reminder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureNavigationBar()
    }
    
    init(reminder: Reminder?) {
        super.init(nibName: nil, bundle: nil)
        self.reminder = reminder
        self.configureUI(for: reminder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: SFSymbols.back, style: .done, target: self, action:#selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func layoutUI() {
//        view.addSubview()
        
        NSLayoutConstraint.activate([
        
        
        ])
    }
    
    private func configureUI(for reminder: Reminder?) {
        guard let reminder = reminder else {
            presentMMAlertOnMainThread(title: "Unable to update UI", message: MMError.unableToUpdateUI.localizedDescription, buttonTitle: "OK")
            return
        }
        
    }
    
    private func editLabels(for reminder: Reminder) {
        DispatchQueue.main.async {
            
        }
    }
    
    @objc private func backButtonTapped() {
         dismiss(animated: true)
     }
}
