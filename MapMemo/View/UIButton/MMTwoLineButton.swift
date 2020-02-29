//
//  MMTwoLineButton.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 29/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

//import UIKit
//
//class MMTwoLineButton: UIButton {
//    
//    enum Mode { case single, split }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    convenience init(title: String, subtitle: String, mode: Mode) {
//        self.init()
//        switch mode {
//        case .single: setSingleTitle(title: title)
//        case .split:  setSplitTitle(title: title, subtitle: subtitle)
//        }
//    }
//    
//    private func configureView() {
//        translatesAutoresizingMaskIntoConstraints = false
//        layer.cornerRadius        = 5
//        backgroundColor           = .systemPink
//        titleLabel?.textColor     = .white
//        titleLabel?.textAlignment = .center
//    }
//    
//    private func setSingleTitle(title: String) {
//        titleLabel?.font    = UIFont.systemFont(ofSize: 18.0, weight: .medium)
//        setTitle(title, for: .normal)
//    }
//    
//    func setSplitTitle(title: String, subtitle: String) {
//        titleLabel?.lineBreakMode    = NSLineBreakMode.byWordWrapping
//        
//        let buttonText: String       = "\(title)\n\(subtitle)"
//        let buttonNSString: NSString = NSString(string: buttonText)
//        let newLineRange: NSRange    = buttonNSString.range(of: "\n")
//        
//        let mainString = buttonNSString.substring(to: newLineRange.location)
//        let subString  = buttonNSString.substring(from: newLineRange.location)
//        
//        let titleFont: UIFont        = UIFont.systemFont(ofSize: 18, weight: .medium)
//        let subtitleFont: UIFont     = UIFont.systemFont(ofSize: 14, weight: .regular)
//        
//        let titleAttribute           = [NSMutableAttributedString.Key.font: titleFont]
//        let subtitleAttribute        = [NSMutableAttributedString.Key.font: subtitleFont]
//
//        let attributedTitleString    = NSMutableAttributedString(string: mainString, attributes: titleAttribute)
//        let attributedSubtitleString = NSMutableAttributedString(string: subString, attributes: subtitleAttribute)
//
//        attributedTitleString.append(attributedSubtitleString)
//        
//        setAttributedTitle(attributedTitleString, for: .normal)
//    }
//}
