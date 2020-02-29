//
//  MMSecondaryTitleLabel.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 29/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMSecondaryTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(alignment: NSTextAlignment, text: String) {
        self.init()
        self.textAlignment = alignment
        self.text          = text
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor             = .clear
        textColor                   = .white
        font                        = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.75
        lineBreakMode               = .byTruncatingTail
    }
}
