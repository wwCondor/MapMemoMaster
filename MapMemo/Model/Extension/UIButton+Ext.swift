//
//  UIButton+Ext.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 29/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setSplitTitle(title: String, subtitle: String) {
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel?.textColor     = .white
        titleLabel?.textAlignment = .center
        
        let buttonText: String       = "\(title)\n\(subtitle)"
        let buttonNSString: NSString = NSString(string: buttonText)
        let newLineRange: NSRange    = buttonNSString.range(of: "\n")
        
        let mainString = buttonNSString.substring(to: newLineRange.location)
        let subString  = buttonNSString.substring(from: newLineRange.location)
        
        let titleFont: UIFont        = UIFont.systemFont(ofSize: 18, weight: .medium)
        let subtitleFont: UIFont     = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        let titleAttribute           = [NSMutableAttributedString.Key.font: titleFont]
        let subtitleAttribute        = [NSMutableAttributedString.Key.font: subtitleFont]
        
        let attributedTitleString    = NSMutableAttributedString(string: mainString, attributes: titleAttribute)
        let attributedSubtitleString = NSMutableAttributedString(string: subString, attributes: subtitleAttribute)
        
        attributedTitleString.append(attributedSubtitleString)
        
        setAttributedTitle(attributedTitleString, for: .normal)
    }
}
