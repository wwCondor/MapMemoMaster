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
    
//    enum Section { case main }
    
    let coreDataManager = CoreDataManager.shared
    let fetchedResultsController = CoreDataManager.shared.fetchedResultsController
    
//    var dataSource: UITableViewDiffableDataSource<Section, Reminder>!
    
    private let remindersTableView = MMRemindersTableView(frame: .zero)
    
//    let fetchedResultsController = CoreDataManager.shared.fetchedResultsController
    



    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        
        configureNavigationBar()
        configureTableView()
        layoutUI()
        
        fetchReminders()
    }
    
    private func fetchReminders() {
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            presentAlert(description: ReminderError.fetchReminder.localizedDescription, viewController: self)
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureTableView() {
        remindersTableView.dataSource = self
        remindersTableView.delegate = self
    }
    
    private func layoutUI() {
        view.addSubview(remindersTableView)
        remindersTableView.pinToEdges(of: view)
    }
    
//    private func configureDataSource() {
//        dataSource = UITableViewDiffableDataSource<Section, Reminder>(tableView: remindersTableView, cellProvider: { (tableView, indexPath, reminder) -> UITableViewCell? in
//            let cell = tableView.dequeueReusableCell(withIdentifier: MMReminderCell.identifier, for: indexPath) as! MMReminderCell
//            cell.set(reminder: reminder)
//            return cell
//        })
//    }
    
//    private func updateData(on reminders: [Reminder]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Reminder>()
//        snapshot.deleteAllItems()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(reminders)
//        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
//    }


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
        let reminder = fetchedResultsController.object(at: indexPath)
        reminder.isActive = status
        print("Reminder at index: \(indexPath) is now active:\(reminder.isActive)")
        reminder.managedObjectContext?.saveChanges()
    }
}

extension ReminderListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminder = fetchedResultsController.object(at: indexPath)
        let cell = remindersTableView.dequeueReusableCell(withIdentifier: MMReminderCell.identifier, for: indexPath) as! MMReminderCell
        cell.selectionStyle = .none
        cell.activationSwitch.tag = indexPath.row
        cell.activationSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        cell.set(reminder: reminder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reminder = fetchedResultsController.object(at: indexPath)
        
        let deleteHandler: UIContextualAction.Handler = { action, view, callback in
            reminder.managedObjectContext?.delete(reminder)
            reminder.managedObjectContext?.saveChanges()
            tableView.reloadData()
            callback(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: deleteHandler)
        deleteAction.backgroundColor = .systemPink
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeAction
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = fetchedResultsController.object(at: indexPath)
        presentReminderVC(mode: .edit, reminder: reminder)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

#warning("Move FRC -> CDM or as Ext")
extension ReminderListVC: NSFetchedResultsControllerDelegate {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        remindersTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {

        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            remindersTableView.insertRows(at: [newIndexPath], with: .automatic)

        case .delete:
            guard let indexPath = indexPath else { return }
            remindersTableView.deleteRows(at: [indexPath], with: .automatic)

        case .move, .update:
            guard let newIndexPath = newIndexPath else { return }
            remindersTableView.reloadRows(at: [newIndexPath], with: .automatic)

        @unknown default:
            return
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        remindersTableView.endUpdates()
    }
}
