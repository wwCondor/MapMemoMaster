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
    
    private let remindersTableView = MMRemindersTableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        configureNavigationBar()
        configureTableView()
        addObserver()
        fetchReminders()
        configureDataSource()
    }
    
    private func layoutUI() {
        view.addSubview(remindersTableView)
        remindersTableView.pinToEdges(of: view)
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
