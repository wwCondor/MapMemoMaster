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
    
    enum Section { case main }
    
    var dataSource: UITableViewDiffableDataSource<Section, Reminder>!
    
    private let remindersTableView = UITableView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        configureNavigationBar()
        configureTableView()
        layoutUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.barTintColor = .systemBackground
//        navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func configureTableView() {
        remindersTableView.backgroundColor = .systemBackground
    }
    
    private func layoutUI() {
        view.addSubview(remindersTableView)
        remindersTableView.pinToEdges(of: view)
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Reminder>(tableView: remindersTableView, cellProvider: { (tableView, indexPath, reminder) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: MMReminderCell.identifier, for: indexPath) as! MMReminderCell
            cell.set(reminder: reminder)
            return cell
        })
    }
    
    private func updateData(on reminders: [Reminder]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Reminder>()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(reminders)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }


    @objc private func addButtonTapped() {
        let reminderVC = ReminderVC()
        let navigationController = UINavigationController(rootViewController: reminderVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

extension ReminderListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
