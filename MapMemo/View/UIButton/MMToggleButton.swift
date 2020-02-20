//
//  MMToggleButton.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

enum Button {
    case triggerButton, repeatButtton
}

class MMToggleButton: UIButton {
    
    var isOn = false
    var toggleTitles: [String] = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(buttonType: Button, title: String) {
        self.init(frame: .zero)
        setTitleForButton(buttonType: buttonType)
        self.setTitle(title, for: .normal)
    }
    
    private func setTitleForButton(buttonType: Button) {
        switch buttonType {
        case .triggerButton: toggleTitles = [ToggleText.enteringTrigger, ToggleText.leavingTrigger]
        case .repeatButtton: toggleTitles = [ToggleText.isRepeating, ToggleText.isNotRepeating]
        }
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5//frame.size.height/2
//        layer.borderColor = UIColor.systemPink.cgColor
//        layer.borderWidth = 2
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        setTitleColor(.white, for: .normal)
        backgroundColor = .systemPink
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        setTitle(ToggleText.leavingTrigger, for: .normal)
    }
    
    @objc private func buttonTapped() {
        toggleButton(bool: !isOn)
    }
    
    private func toggleButton(bool: Bool) {
        isOn = bool
        
//        let buttonColor: UIColor = bool ? .yellow : .white
        let buttonTitle: String = bool ? toggleTitles[0] : toggleTitles[1]
//        let titleColor: UIColor = bool ? .red : .blue
        
//        backgroundColor = buttonColor
        setTitle(buttonTitle, for: .normal)
//        setTitleColor(titleColor, for: .normal)
    }
}

