//
//  MMButton.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 20/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.font    = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        layer.cornerRadius  = 5
        backgroundColor     = .systemPink
        setTitleColor(.white, for: .normal)
    }
}
