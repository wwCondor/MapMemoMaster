//
//  ReminderVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

enum ReminderMode { case new, edit }

class ReminderVC: UIViewController {
    
//    var reminder: Reminder?

    var reminderLatitude: Double?
    var reminderLongitude: Double?
    
    var radiusInMeters: Double      = 50
    var modeSelected: ReminderMode  = .new

    let managedObjectContext        = CoreDataManager.shared.managedObjectContext
    
    private let locationButton          = MMButton(title: PlaceHolderText.location)
    private let titleTextField          = MMTextField(placeholder: PlaceHolderText.title)
    private let messageTextField        = MMTextField(placeholder: PlaceHolderText.message)
    private let triggerToggleButton     = MMToggleButton(buttonType: .triggerButton, title: ToggleText.leavingTrigger)
    private let repeatToggleButton      = MMToggleButton(buttonType: .repeatButtton, title: ToggleText.isNotRepeating)
    private let radiusSlider            = MMSlider()
    private let radiusLabel             = MMTitleLabel(alignment: .center, text: PlaceHolderText.defaultRadius)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDismissKeyboardTapGesture()

        view.backgroundColor = .systemBackground

        configureNavigationBar()
        layoutUI()
        configureTargets()
    }

    init(mode: ReminderMode) {
        super.init(nibName: nil, bundle: nil)
        modeSelected = mode
        configureUI(for: mode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(for mode: ReminderMode) {
        switch mode {
        case .new: print("New")
        case .edit: print("Edit")
        }
    }
    
    private func configureNavigationBar() {
        let backButtton = UIBarButtonItem(image: SFSymbols.back, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtton
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }

    private func configureTargets() {
        radiusSlider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    @objc func sliderMoved(sender: UISlider) {
        sender.value = roundf(sender.value)
        let radiiInMeters: [Double] = [10, 25, 50, 100, 500, 1000, 5000]
        let radiusSelected = Double(radiiInMeters[Int(roundf(sender.value))])
        radiusInMeters = radiusSelected
        radiusLabel.text = "Bubble radius: \(radiusSelected.clean)m"
    }
    
    private func layoutUI() {
        view.addSubviews(locationButton, titleTextField, messageTextField, triggerToggleButton, repeatToggleButton, radiusSlider, radiusLabel)
        
        let padding: CGFloat = 20
        let height: CGFloat = 60
        
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationButton.heightAnchor.constraint(equalToConstant: height),
            
            titleTextField.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: padding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: height),
            
            messageTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: padding),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            messageTextField.heightAnchor.constraint(equalToConstant: height),
            
            triggerToggleButton.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: padding),
            triggerToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            triggerToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            triggerToggleButton.heightAnchor.constraint(equalToConstant: height),
            
            repeatToggleButton.topAnchor.constraint(equalTo: triggerToggleButton.bottomAnchor, constant: padding),
            repeatToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            repeatToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            repeatToggleButton.heightAnchor.constraint(equalToConstant: height),
            
            radiusSlider.topAnchor.constraint(equalTo: repeatToggleButton.bottomAnchor, constant: padding),
            radiusSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            radiusSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            radiusSlider.heightAnchor.constraint(equalToConstant: height),
            
            radiusLabel.topAnchor.constraint(equalTo: radiusSlider.bottomAnchor),
            radiusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            radiusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            radiusLabel.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        saveReminder()
        dismiss(animated: true)
    }
    
    @objc private func locationButtonTapped() {
        let locationVC = LocationVC()
        locationVC.delegate = self
        let navigationController = UINavigationController(rootViewController: locationVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    private func saveReminder() {
        switch modeSelected {
        case .new: saveNewReminder()
        case .edit: saveReminderChanges()
        }
    }
    
    private func saveNewReminder() {
//        guard let title = titleTextField.text, !title.isEmpty, title != PlaceHolderText.title else {
//            presentAlert(description: ReminderError.missingTitle.localizedDescription, viewController: self)
//            return
//        }
//        guard let message = messageTextField.text, !message.isEmpty, message != PlaceHolderText.message else {
//            presentAlert(description: ReminderError.missingMessage.localizedDescription, viewController: self)
//            return
//        }
//        guard let locationName = locationSearchBar.text, !locationName.isEmpty else {
//            presentAlert(description: ReminderError.missingLocationName.localizedDescription, viewController: self)
//            return
//        }
//        
//        guard let latitude = reminderLatitude, reminderLatitude != nil else {
//            presentAlert(description: ReminderError.missingLatitude.localizedDescription, viewController: self)
//            return
//            
//        }
//        guard let longitude = reminderLongitude, reminderLatitude != nil else {
//            presentAlert(description: ReminderError.missingLongitude.localizedDescription, viewController: self)
//            return
//        }
//        
//        let reminder = Reminder(context: managedObjectContext)
//        
//        reminder.title               = title
//        reminder.message             = message
//        reminder.latitude            = latitude
//        reminder.longitude           = longitude
//        reminder.locationName        = locationName
//        reminder.triggerOnEntry = triggerToggleButton.isOn
//        reminder.isRepeating         = repeatToggleButton.isOn
//        reminder.isActive            = true
//        reminder.bubbleRadius        = radiusInMeters
//        
//        reminder.managedObjectContext?.saveChanges()
//        print("saving new reminder")
    }
    
    private func saveReminderChanges() {
//        print("saving reminder changes")
//        
//        guard let reminder = reminder else {
//            presentAlert(description: ReminderError.reminderNil.localizedDescription, viewController: self)
//            return
//        }
//        
//        guard let newTitle = titleTextField.text else {
//            presentAlert(description: ReminderError.missingTitle.localizedDescription, viewController: self)
//            return
//        }
//        
//        guard let newMessage = messageTextField.text else {
//            presentAlert(description: ReminderError.missingMessage.localizedDescription, viewController: self)
//            return
//        }
//        guard let newLatitude = reminderLatitude else {
//            presentAlert(description: ReminderError.missingLatitude.localizedDescription, viewController: self)
//            return
//        }
//            
//        guard let newLongitude = reminderLongitude else {
//            presentAlert(description: ReminderError.missingLongitude.localizedDescription, viewController: self)
//            return
//        }
//        
//        guard let newLocationName = locationSearchBar.text else {
//            presentAlert(description: ReminderError.missingLocationName.localizedDescription, viewController: self)
//            return
//        }
//        
//        reminder.title = newTitle
//        reminder.message = newMessage
//        reminder.latitude = newLatitude
//        reminder.longitude = newLongitude
//        reminder.locationName = newLocationName
//        reminder.bubbleRadius = Double(radiusInMeters)
//        
//        reminder.managedObjectContext?.saveChanges()
    }
}

extension ReminderVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharactersIntitle = 20
        let maxCharactersInMessage = 40

        switch textField {
        case titleTextField:
            let currentString = titleTextField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxCharactersIntitle
        case messageTextField:
            let currentString = messageTextField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxCharactersInMessage
        default:
            return true // Allows backspace
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
//        // If current text is placeholder text, reset it to ""
//        guard let text = textField.text else { return }
//
//        switch textField {
//        case titleTextField:
//            if text == PlaceHolderText.title {
//                textField.text = ""
//            }
//        case messageTextField:
//            if text == PlaceHolderText.message {
//                textField.text = ""
//            }
//        default: break
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        guard let input = textField.text else { return }
        
        switch textField {
        case titleTextField: guard input.isEmpty else {
            titleTextField.text = PlaceHolderText.title
            return
            }
            
            //            if input.isEmpty {
            //                titleTextField.text = PlaceHolderText.title
        //            }
        case messageTextField: guard input.isEmpty else {
            messageTextField.text = PlaceHolderText.message
            return
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ReminderVC: LocationDelegate {
    func locationSelected(name: String, latitude: Double, longitude: Double) {
        locationButton.setTitle(name, for: .normal)
        reminderLatitude = latitude
        reminderLongitude = longitude
        print("\(name) with coordinates: \(latitude), \(longitude) obtained.")
    }
}



