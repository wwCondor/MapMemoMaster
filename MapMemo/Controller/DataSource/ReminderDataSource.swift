//
//  ReminderDataSource.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 22/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

enum Section { case main }

class ReminderDataSource: UITableViewDiffableDataSource<Section, Reminder> {
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
}
