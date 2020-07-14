//
//  UIStackView+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 14/07/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views { addArrangedSubview(view) }
    }
}
