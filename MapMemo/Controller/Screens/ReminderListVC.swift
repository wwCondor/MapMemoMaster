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
    
    var dataSource: ReminderDataSource!
    
    private let updateRemindersKey   = Notification.Name(rawValue: Key.updateReminders)
    private let coreDataManager      = CoreDataManager.shared
    private let notificationManager  = NotificationManager.shared
        
    private let remindersTableView        = MMRemindersTableView(frame: .zero)
    private let largeBackgroundImageView  = MMImageView(image: SFSymbols.pin!, tintColor: UIColor.systemPink.withAlphaComponent(0.35))
    private let mediumBackgroundImageView = MMImageView(image: SFSymbols.pin!, tintColor: UIColor.systemPink.withAlphaComponent(0.25))
    private let smallBackgroundImageView  = MMImageView(image: SFSymbols.pin!, tintColor: UIColor.systemPink.withAlphaComponent(0.15))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUI()
        configureNavigationBar()
        configureTableView()
        fetchReminders()
        updateData()
        configureDataSource()
    }
    
    private func layoutUI() {
        view.addSubviews(largeBackgroundImageView, mediumBackgroundImageView, smallBackgroundImageView, remindersTableView)
        
        NSLayoutConstraint.activate([
            smallBackgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            smallBackgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 40),
            smallBackgroundImageView.heightAnchor.constraint(equalToConstant: 100),
            smallBackgroundImageView.widthAnchor.constraint(equalToConstant: 100),
            
            mediumBackgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mediumBackgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mediumBackgroundImageView.heightAnchor.constraint(equalToConstant: 200),
            mediumBackgroundImageView.widthAnchor.constraint(equalToConstant: 200),
            
            largeBackgroundImageView.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            largeBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            largeBackgroundImageView.heightAnchor.constraint(equalToConstant: 300),
            largeBackgroundImageView.widthAnchor.constraint(equalToConstant: 300),
            
            remindersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            remindersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            remindersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            remindersTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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

    private func fetchReminders() {
        coreDataManager.fetchedResultsController.delegate = self
        do {
            try coreDataManager.fetchedResultsController.performFetch()
//            updateData()
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
        snapshot.appendItems(coreDataManager.fetchedResultsController.fetchedObjects ?? [])
        snapshot.reloadItems(coreDataManager.fetchedResultsController.fetchedObjects ?? [])
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
//    @objc private func updateReminders(sender: NotificationCenter) {
//        updateData()
////        configureDataSource()
//    }

    @objc private func addButtonTapped() {
        presentReminderVC(mode: .new, reminder: nil)
    }
    
    private func presentReminderVC(mode: ReminderMode, reminder: Reminder?) {
        let reminderVC = ReminderVC(mode: mode, reminder: reminder)
//        reminderVC.reminderVCListDelegate = self
        let navigationController = UINavigationController(rootViewController: reminderVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func switchToggled(sender: UISwitch) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let reminder = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        let status: Bool = sender.isOn ? true : false
        coreDataManager.switchStatus(for: reminder, to: status)
        updateData()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
}

extension ReminderListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            guard let reminder = self.dataSource?.itemIdentifier(for: indexPath), let identifier = reminder.identifier else { return }
            self.notificationManager.notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
            self.coreDataManager.delete(reminder: reminder)
            NotificationCenter.default.post(name: self.updateRemindersKey, object: nil)
            completion(true)
        }
        
        deleteAction.image = SFSymbols.delete
        deleteAction.backgroundColor = .systemPink
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            guard let reminder = self.dataSource?.itemIdentifier(for: indexPath) else { return }
            self.presentReminderVC(mode: .edit, reminder: reminder)
            completion(true)
        }
        
        editAction.backgroundColor = .systemPink
        editAction.image = SFSymbols.edit
        
        let swipeAction = UISwipeActionsConfiguration(actions: [editAction])
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

extension ReminderListVC: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateData()
    }
}
