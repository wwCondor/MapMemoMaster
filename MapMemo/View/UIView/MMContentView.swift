//
//  MMContentView.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMContentView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(borderColor: UIColor, cornerRadius: CGFloat) {
        self.init()
        self.layer.borderColor  = borderColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }

    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor     = .systemPink
        layer.borderWidth   = 2
        layer.masksToBounds = true
    }
}
