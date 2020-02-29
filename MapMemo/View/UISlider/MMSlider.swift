//
//  MMSlider.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 19/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMSlider: UISlider {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor        = UIColor.clear
        minimumTrackTintColor  = .red
        maximumTrackTintColor  = .systemGray4
        thumbTintColor         = .systemPink
        minimumValue           = 0
        maximumValue           = 6
        setValue(2, animated: true)
    }
}
