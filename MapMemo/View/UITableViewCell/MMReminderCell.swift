//
//  MMReminderCell.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMReminderCell: UITableViewCell {

    static let identifier = "reminderCellId"
    
    private let contentBackgroundView = MMBackgroundView(backgroundColor: .systemOrange, cornerRadius: 5)
    private let iconBackgroundView = MMBackgroundView(backgroundColor: .systemOrange, cornerRadius: 10)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
        configureCellContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        backgroundColor = .black
    }
    
    private func configureCellContent() {
        addSubviews(iconBackgroundView, contentBackgroundView)
    }
    
    func set(reminder: Reminder) {
        // Here we set all the content with reminder info
    }
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//
//    }

}
