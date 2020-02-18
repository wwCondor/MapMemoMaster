//
//  ReminderVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class ReminderVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow

        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let backButtton = UIBarButtonItem(image: SFSymbols.back, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtton
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
//        navigationItem.title = "Add Reminder"
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        saveReminder()
        dismiss(animated: true)
    }
    
    private func saveReminder() {
        print("saving reminder")
    }
}
