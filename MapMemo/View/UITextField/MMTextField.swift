//
//  MMTextField.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor         = .tertiarySystemBackground
        textColor               = .systemPink
        tintColor               = .systemPink
        font                    = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        textAlignment           = .center
        
        layer.masksToBounds     = true
        layer.cornerRadius      = 8
        layer.borderWidth       = 2
        layer.borderColor       = UIColor.systemPink.cgColor
    
//        keyboardAppearance      = .dark
//        spellCheckingType       = .no
//        autocapitalizationType  = .none
//        autocorrectionType      = .no
//        keyboardAppearance      = .dark
//        returnKeyType           = .done
    }
}
