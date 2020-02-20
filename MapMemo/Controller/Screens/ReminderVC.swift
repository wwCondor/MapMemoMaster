//
//  ReminderVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit

enum ReminderMode { case new, edit }

class ReminderVC: UIViewController {
    
//    var reminder: Reminder?

    var reminderLatitude: Double?
    var reminderLongitude: Double?
    
    var radiusInMeters: Double      = 50
    var modeSelected: ReminderMode  = .new
    var searchResults               = [MKLocalSearchCompletion]()

//    let managedObjectContext        = CoreDataManager.shared.managedObjectContext
    let cellId                      = "searchResultsId"
    
    private let searchCompleter         = MKLocalSearchCompleter()
    private let locationSearchBar       = MMLocationSearchBar()
    private let titleTextField          = MMTextField(placeholder: PlaceHolderText.title)
    private let messageTextField        = MMTextField(placeholder: PlaceHolderText.message)
    private let searchResultsTableView  = UITableView()
    private let triggerToggleButton     = MMToggleButton(buttonType: .triggerButton, title: ToggleText.leavingTrigger)
    private let repeatToggleButton      = MMToggleButton(buttonType: .repeatButtton, title: ToggleText.isNotRepeating)
    private let radiusSlider            = MMSlider()
    private let radiusLabel             = MMTitleLabel(alignment: .center, text: "Trigger radius: 0m")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDismissKeyboardTapGesture()

        view.backgroundColor = .systemBackground

        configureNavigationBar()
        layoutUI()
        configureTargets()
        configureSearchResultsTableView()
        setDelegates()
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
//        navigationItem.title = "Add Reminder"
    }
    
    private func configureSearchResultsTableView() {
        searchResultsTableView.backgroundColor = UIColor.clear
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureTargets() {
        radiusSlider.addTarget(self, action: #selector(sliderMoved), for: .valueChanged)
    }
    
    @objc func sliderMoved(sender: UISlider) {
//        view.endEditing(true)
        sender.value = roundf(sender.value) // this allows thumb to snap between values
        let radiiInMeters: [Double] = [10, 25, 50, 100, 500, 1000, 5000]
        let radiusSelected = Double(radiiInMeters[Int(roundf(sender.value))])
        radiusInMeters = radiusSelected
        radiusLabel.text = "Bubble radius: \(radiusSelected.clean)m"
    }
    
    private func layoutUI() {
        view.addSubviews(locationSearchBar, searchResultsTableView, titleTextField, messageTextField, triggerToggleButton, repeatToggleButton, radiusSlider, radiusLabel)
        
        let padding: CGFloat = 10
        let sliderPadding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            locationSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            locationSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationSearchBar.heightAnchor.constraint(equalToConstant: 60),
            
            searchResultsTableView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor, constant: padding),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchResultsTableView.heightAnchor.constraint(equalToConstant: 200),
            
            titleTextField.topAnchor.constraint(equalTo: searchResultsTableView.bottomAnchor, constant: padding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),
            
            messageTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: padding),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            messageTextField.heightAnchor.constraint(equalToConstant: 48),
            
            triggerToggleButton.topAnchor.constraint(equalTo: messageTextField.bottomAnchor, constant: padding),
            triggerToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            triggerToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            triggerToggleButton.heightAnchor.constraint(equalToConstant: 48),
            
            repeatToggleButton.topAnchor.constraint(equalTo: triggerToggleButton.bottomAnchor, constant: padding),
            repeatToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            repeatToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            repeatToggleButton.heightAnchor.constraint(equalToConstant: 48),
            
            radiusSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sliderPadding),
            radiusSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sliderPadding),
            radiusSlider.heightAnchor.constraint(equalToConstant: 48),
            radiusSlider.bottomAnchor.constraint(equalTo: radiusLabel.topAnchor),
            
            radiusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sliderPadding),
            radiusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sliderPadding),
            radiusLabel.heightAnchor.constraint(equalToConstant: 48),
            radiusLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setDelegates() {
        locationSearchBar.delegate = self
        searchCompleter.delegate = self
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        saveReminder()
        dismiss(animated: true)
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

extension ReminderVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension ReminderVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadDataOnMainThread()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
        #warning("Change to alert")
    }
}

extension ReminderVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.textLabel?.textColor = .systemPink
        cell.detailTextLabel?.textColor = .systemPink
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (result, error) in
            let coordinate = result?.mapItems.last?.placemark.coordinate
            print("Coordinate latitude \(String(describing: coordinate?.latitude.toString)) longitude \(String(describing: coordinate?.longitude.toString))")
            self.reminderLatitude = coordinate?.latitude
            self.reminderLongitude = coordinate?.longitude
//            self.latitudeInputField.text = coordinate?.latitude.toString
//            self.longitudeInputField.text = coordinate?.longitude.toString
            self.locationSearchBar.text = "\(completion.title) in \(completion.subtitle)"
        }
    }
}