//
//  MMImageView.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 19/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage) {
        self.init(frame: .zero)
        self.image = image
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
//        image               = SFSymbols.compass
        tintColor           = .systemPink
        backgroundColor     = .clear
    }
    
}