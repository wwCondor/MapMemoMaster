//
//  RemindersTableView.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class RemindersTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        separatorStyle = .none
        register(MMReminderCell.self, forCellReuseIdentifier: MMReminderCell.identifier)
    }
}
