//
//  MMLabel.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 19/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor       = .systemPink
        textAlignment   = .center
        font            = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        text            = "Trigger bubble Radius: 0m"
    }
}
