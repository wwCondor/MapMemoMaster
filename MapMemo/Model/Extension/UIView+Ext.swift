//
//  UIView+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 2.0) -> [UIView] {

        var borders = [UIView]()
        let borderColor: UIColor = .systemPink

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = borderColor
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }

        if edges.contains(.top)    || edges.contains(.all) {addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")}
        if edges.contains(.bottom) || edges.contains(.all) {addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")}
        if edges.contains(.left)   || edges.contains(.all) {addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")}
        if edges.contains(.right)  || edges.contains(.all) {addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")}

        return borders
    }
}
