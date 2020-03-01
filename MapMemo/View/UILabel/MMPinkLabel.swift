//
//  MMPinkLabel.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 01/03/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMPinkLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(text: String) {
        self.init()
        self.text          = text
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor             = .clear
        textAlignment               = .center
        textColor                   = UIColor.systemPink.withAlphaComponent(0.8)
        font                        = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
    }
}
