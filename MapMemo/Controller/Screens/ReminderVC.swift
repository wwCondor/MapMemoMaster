//
//  ReminderVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

enum ReminderMode { case new, edit, annotation }

//protocol ReminderVCListDelegate: class {
//    func didEdit(reminder: Reminder)
//}
//
//protocol ReminderVCMapDelegate: class {
//
//}

class ReminderVC: UIViewController {
    
    private let updateRemindersKey = Notification.Name(rawValue: Key.updateReminders)
    
//    weak var reminderVCListDelegate: ReminderVCListDelegate!
    
    var reminder: Reminder?
    var locationName: String?
    var locationAddress: String?
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
    private let radiusLabel             = MMPinkLabel(text: PlaceHolderText.defaultRadius)
    
    private let radiiInMeters: [Double] = [10, 25, 50, 100, 500, 1000, 5000]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDismissKeyboardTapGesture()

        view.backgroundColor = .systemBackground

        configureNavigationBar()
        layoutUI()
        configureTargets()
        
        titleTextField.delegate = self
        messageTextField.delegate = self
    }

    init(mode: ReminderMode, reminder: Reminder?) {
        super.init(nibName: nil, bundle: nil)
        self.reminder = reminder
        modeSelected = mode
        configureUI(for: mode, with: reminder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationBar() {
        let backButtton = UIBarButtonItem(image: SFSymbols.back, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtton
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func layoutUI() {
        view.addSubviews(locationButton, titleTextField, messageTextField, triggerToggleButton, repeatToggleButton, radiusSlider, radiusLabel)
        
        let padding: CGFloat = 20
        let itemHeight: CGFloat  = 60
        
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationButton.heightAnchor.constraint(equalToConstant: itemHeight),
            
            titleTextField.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: padding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: itemHeight),
            
            messageTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: padding),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            messageTextField.heightAnchor.constraint(equalToConstant: itemHeight),
            
            triggerToggleButton.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: padding),
            triggerToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            triggerToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            triggerToggleButton.heightAnchor.constraint(equalToConstant: itemHeight),
            
            repeatToggleButton.topAnchor.constraint(equalTo: triggerToggleButton.bottomAnchor, constant: padding),
            repeatToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            repeatToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            repeatToggleButton.heightAnchor.constraint(equalToConstant: itemHeight),
            
            radiusSlider.topAnchor.constraint(equalTo: repeatToggleButton.bottomAnchor, constant: padding),
            radiusSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            radiusSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            radiusSlider.heightAnchor.constraint(equalToConstant: itemHeight),
            
            radiusLabel.topAnchor.constraint(equalTo: radiusSlider.bottomAnchor),
            radiusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            radiusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            radiusLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func configureTargets() {
        radiusSlider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    }
    
    private func configureUI(for mode: ReminderMode, with reminder: Reminder?) {
        switch mode {
        case .new:
            print("ReminderVC presented in New Mode")
        case .edit:
            guard let selectedReminder = reminder else { return }
            updateLabels(for: selectedReminder)
            print("ReminderVC presented in Edit Mode")
        case .annotation:
            updateButtonInfo()
            print("ReminderVC presented in Annotation Mode")
        }
    }
    
    private func updateSlider(for radius: Double) {
        var index: Float = 0

        for radiusInMeters in radiiInMeters {
            if radiusInMeters == radius {
                radiusSlider.setValue(index, animated: true)
            } else {
                index += 1
            }
        }
    }
    
    private func updateLabels(for reminder: Reminder) {
        DispatchQueue.main.async {
            self.locationName               = reminder.locationName
            self.locationAddress            = reminder.locationAddress
                        
            self.titleTextField.text        = reminder.title
            self.messageTextField.text      = reminder.message

            self.triggerToggleButton.isOn   = reminder.triggerOnEntry
            let triggerButtonTitle          = reminder.triggerOnEntry ? ToggleText.enteringTrigger : ToggleText.leavingTrigger
            self.triggerToggleButton.setTitle(triggerButtonTitle , for: .normal)
            
            self.repeatToggleButton.isOn    = reminder.isRepeating
            let repeatButtonTitle           = reminder.isRepeating ? ToggleText.isRepeating : ToggleText.isNotRepeating
            self.repeatToggleButton.setTitle(repeatButtonTitle, for: .normal)
            
            self.radiusInMeters             = reminder.bubbleRadius
            self.radiusLabel.text           = "Bubble radius: \(reminder.bubbleRadius.clean)m"
            self.reminderLatitude           = reminder.latitude
            self.reminderLongitude          = reminder.longitude
            
            self.updateSlider(for: reminder.bubbleRadius)
            guard let title = reminder.locationName, let subtitle = reminder.locationAddress else { return }
            self.locationButton.setSplitTitle(title: title, subtitle: subtitle)
        }
    }
    
    private func updateButtonInfo() {
        DispatchQueue.main.async {
            guard let title = self.locationName, let subtitle = self.locationAddress else {
                print("Unable to set button titel")
                return
            }
            self.locationButton.setSplitTitle(title: title, subtitle: subtitle)
        }
    }

    @objc func sliderMoved(sender: UISlider) {
        sender.value = roundf(sender.value)
        let radiusSelected = Double(radiiInMeters[Int(roundf(sender.value))])
        radiusInMeters = radiusSelected
        radiusLabel.text = "Bubble radius: \(radiusSelected.clean)m"
    }
    
    @objc private func backButtonTapped() {
         dismiss(animated: true)
     }
     
     @objc private func saveButtonTapped() {
         saveReminder()
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
        case .annotation: saveNewReminder()
        }
    }
    
    private func saveNewReminder() {
        guard let title = titleTextField.text, title.isNotEmpty, title != PlaceHolderText.title else {
            presentMMAlertOnMainThread(title: "Missing Title", message: MMReminderError.missingTitle.localizedDescription, buttonTitle: "OK")
            return
        }
        
        guard let message = messageTextField.text, message.isNotEmpty, message != PlaceHolderText.message else {
            presentMMAlertOnMainThread(title: "Missing Message", message: MMReminderError.missingMessage.localizedDescription, buttonTitle: "OK")
            return
        }
        
        guard let locationName = locationName, locationName.isNotEmpty else {
            presentMMAlertOnMainThread(title: "Missing Location Name", message: MMReminderError.missingLocationName.localizedDescription, buttonTitle: "Ok")
            return
        }
        
        guard let locationAddress = locationAddress, locationAddress.isNotEmpty else {
            presentMMAlertOnMainThread(title: "Missing Location Name", message: MMReminderError.missingLocationAddress.localizedDescription, buttonTitle: "Ok")
            return
        }
        
        guard let latitude = reminderLatitude, reminderLatitude != nil else {
            presentMMAlertOnMainThread(title: "Missing Latitude", message: MMReminderError.missingLatitude.localizedDescription, buttonTitle: "OK")
            return
            
        }
        guard let longitude = reminderLongitude, reminderLatitude != nil else {
            presentMMAlertOnMainThread(title: "Missing Longitude", message: MMReminderError.missingLongitude.localizedDescription, buttonTitle: "OK")
            return
        }
        
        let reminder = Reminder(context: managedObjectContext)
        
        reminder.title           = title
        reminder.message         = message
        reminder.latitude        = latitude
        reminder.longitude       = longitude
        reminder.locationName    = locationName
        reminder.locationAddress = locationAddress
        reminder.triggerOnEntry  = triggerToggleButton.isOn
        reminder.isRepeating     = repeatToggleButton.isOn
        reminder.isActive        = true
        reminder.bubbleRadius    = radiusInMeters
        
        reminder.managedObjectContext?.saveChanges()
        NotificationCenter.default.post(name: updateRemindersKey, object: nil)
        dismiss(animated: true)
        print("Saving \(String(describing: reminder.title)) reminder, at \(String(describing: reminder.locationName))")
    }
    
    private func saveReminderChanges() {
        guard let reminder = reminder else {
            presentMMAlertOnMainThread(title: "No Reminder", message: MMReminderError.reminderNil.localizedDescription, buttonTitle: "OK")
            return
        }
        
        guard let newTitle = titleTextField.text else {
            presentMMAlertOnMainThread(title: "Missing Title", message: MMReminderError.missingTitle.localizedDescription, buttonTitle: "OK")
            return
        }
        
        guard let newMessage = messageTextField.text else {
            presentMMAlertOnMainThread(title: "Missing Message", message: MMReminderError.missingMessage.localizedDescription, buttonTitle: "OK")
            return
        }
        
        guard let newLocationName = locationName, newLocationName.isNotEmpty else {
            presentMMAlertOnMainThread(title: "Missing Location", message: MMReminderError.missingLocationName.localizedDescription, buttonTitle: "Ok")
            return
        }
        
        guard let newLocationAddress = locationAddress, newLocationAddress.isNotEmpty else {
            presentMMAlertOnMainThread(title: "Missing Location", message: MMReminderError.missingLocationAddress.localizedDescription, buttonTitle: "Ok")
            return
        }
        
        guard let newLatitude = reminderLatitude else {
            presentMMAlertOnMainThread(title: "Missing Latitude", message: MMReminderError.missingLatitude.localizedDescription, buttonTitle: "OK")
            return
        }
            
        guard let newLongitude = reminderLongitude else {
            presentMMAlertOnMainThread(title: "Missing Longitude", message: MMReminderError.missingLongitude.localizedDescription, buttonTitle: "OK")
            return
        }
        
        reminder.title            = newTitle
        reminder.message          = newMessage
        reminder.latitude         = newLatitude
        reminder.longitude        = newLongitude
        reminder.locationName     = newLocationName
        reminder.locationAddress  = newLocationAddress
        reminder.triggerOnEntry   = triggerToggleButton.isOn
        reminder.isRepeating      = repeatToggleButton.isOn
        reminder.bubbleRadius     = Double(radiusInMeters)
        
        reminder.managedObjectContext?.saveChanges()
//        reminderVCListDelegate.didEdit(reminder: reminder)
        NotificationCenter.default.post(name: updateRemindersKey, object: nil)
        dismiss(animated: true)
        print("Saving \(String(describing: reminder.title)) reminder, at \(String(describing: reminder.locationName))")
    }
}

extension ReminderVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharacters = 24

        switch textField {
        case titleTextField, messageTextField:
            let currentString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxCharacters
        default:
            return true // Allows backspace
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        guard let input = textField.text else { return }
        
        switch textField {
        case titleTextField:
            guard input.isNotEmpty else {
            titleTextField.placeholder = PlaceHolderText.title
            return
            }
        case messageTextField:
            guard input.isNotEmpty else {
            messageTextField.placeholder = PlaceHolderText.message
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
    func locationSelected(title: String, subtitle: String, latitude: Double, longitude: Double) {
        locationButton.setSplitTitle(title: title, subtitle: subtitle)
        locationName      = title
        locationAddress   = subtitle
        reminderLatitude  = latitude
        reminderLongitude = longitude
        print("\(title) with coordinates: \(latitude), \(longitude) obtained.")
    }
}
