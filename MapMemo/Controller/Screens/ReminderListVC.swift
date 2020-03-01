//
//  ReminderListVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData

class ReminderListVC: UIViewController {
    
    private let updateRemindersKey = Notification.Name(rawValue: Key.updateReminders)
    
    let coreDataManager = CoreDataManager.shared
    let fetchedResultsController = CoreDataManager.shared.fetchedResultsController
    
    var dataSource: ReminderDataSource!
    
    private let remindersTableView       = MMRemindersTableView(frame: .zero)
    private let largeRemindersImageView  = MMImageView(image: SFSymbols.pin!, tintColor: UIColor.systemPink.withAlphaComponent(0.35))
    private let mediumRemindersImageView = MMImageView(image: SFSymbols.pin!, tintColor: UIColor.systemPink.withAlphaComponent(0.25))
    private let smallRemindersImageView  = MMImageView(image: SFSymbols.pin!, tintColor: UIColor.systemPink.withAlphaComponent(0.15))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        configureNavigationBar()
        configureTableView()
        fetchReminders()
        configureDataSource()
        addObserver()
    }
    
    private func layoutUI() {
        view.addSubviews(largeRemindersImageView, mediumRemindersImageView, smallRemindersImageView, remindersTableView)
        remindersTableView.pinToEdges(of: view)
        
        NSLayoutConstraint.activate([
            smallRemindersImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            smallRemindersImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            smallRemindersImageView.heightAnchor.constraint(equalToConstant: 100),
            smallRemindersImageView.widthAnchor.constraint(equalToConstant: 100),
            
            mediumRemindersImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mediumRemindersImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mediumRemindersImageView.heightAnchor.constraint(equalToConstant: 200),
            mediumRemindersImageView.widthAnchor.constraint(equalToConstant: 200),
            
            largeRemindersImageView.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            largeRemindersImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            largeRemindersImageView.heightAnchor.constraint(equalToConstant: 300),
            largeRemindersImageView.widthAnchor.constraint(equalToConstant: 300),
            
//            noRemindersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            noRemindersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            noRemindersLabel.topAnchor.constraint(equalTo: noRemindersImageView.bottomAnchor, constant: 20),
//            noRemindersLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureTableView() {
        remindersTableView.delegate = self
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateReminders), name: updateRemindersKey, object: nil)
    }

    private func fetchReminders() {
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            updateData()
        } catch {
            presentMMAlertOnMainThread(title: "Reminder Fetch Error", message: MMError.failedFetch.localizedDescription, buttonTitle: "OK")
        }
    }
    
    private func configureDataSource() {
        dataSource = ReminderDataSource(tableView: remindersTableView, cellProvider: { (tableView, indexPath, reminder) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: MMReminderCell.identifier, for: indexPath) as! MMReminderCell
            cell.set(reminder: reminder)
            cell.selectionStyle = .none
            cell.activationSwitch.tag = indexPath.row
            cell.activationSwitch.addTarget(self, action: #selector(self.switchToggled), for: .valueChanged)
            return cell
        })
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Reminder>()
        snapshot.appendSections([.main])
        snapshot.appendItems(fetchedResultsController.fetchedObjects ?? [])
        snapshot.reloadItems(fetchedResultsController.fetchedObjects ?? [])
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    @objc private func updateReminders(sender: NotificationCenter) {
        updateData()
    }

    @objc private func addButtonTapped() {
        presentReminderVC(mode: .new, reminder: nil)
    }
    
    private func presentReminderVC(mode: ReminderMode, reminder: Reminder?) {
        let reminderVC = ReminderVC(mode: mode, reminder: reminder)
        let navigationController = UINavigationController(rootViewController: reminderVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func switchToggled(sender: UISwitch) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let isStatusActive: Bool = sender.isOn ? true : false
        changeReminderStatus(at: indexPath, to: isStatusActive)
    }
    
    private func changeReminderStatus(at indexPath: IndexPath, to status: Bool) {
        guard let reminder = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        reminder.isActive = status
        print("Reminder at index: \(indexPath) is now active:\(reminder.isActive)")
        reminder.managedObjectContext?.saveChanges()
        NotificationCenter.default.post(name: updateRemindersKey, object: nil)
        updateData()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
}

extension ReminderListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            guard let reminder = self.dataSource?.itemIdentifier(for: indexPath) else { return }
            reminder.managedObjectContext?.delete(reminder)
            reminder.managedObjectContext?.saveChanges()
            self.updateData()
            NotificationCenter.default.post(name: self.updateRemindersKey, object: nil)
            completion(true)
        }
        
        deleteAction.image = SFSymbols.delete
        deleteAction.backgroundColor = .systemPink
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            guard let reminder = self.dataSource?.itemIdentifier(for: indexPath) else { return }
            self.presentReminderVC(mode: .edit, reminder: reminder)
            completion(true)
        }
        
        action.backgroundColor = .systemPink
        action.image = SFSymbols.edit
        
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let reminder = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        presentReminderVC(mode: .edit, reminder: reminder)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
}

#warning("Move FRC -> CDM or as Ext")
extension ReminderListVC: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateData()
    }
}
