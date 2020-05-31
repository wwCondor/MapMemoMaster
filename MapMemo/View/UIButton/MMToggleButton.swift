//
//  MMToggleButton.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

enum Button { case triggerButton, repeatButtton }

// Button specifically used for toggling on/off repeat and toggle between trigger mode.
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
        layer.cornerRadius  = 5
        titleLabel?.font    = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        backgroundColor     = .systemPink
        setTitleColor(.white, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        toggleButton(bool: !isOn)
    }
    
    private func toggleButton(bool: Bool) {
        isOn = bool

        let buttonTitle: String = bool ? toggleTitles[0] : toggleTitles[1]

        setTitle(buttonTitle, for: .normal)
    }
}
