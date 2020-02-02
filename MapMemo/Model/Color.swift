//
//  Color.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// Used for storing colors as string to CoreData
enum Color {
    case bubbleRed
    case bubbleYellow
    case bubbleBlue
    case bubbleOrange
    case bubblePink
    case bubbleGreen

    var name: String {
        switch self {
        case .bubbleRed:      return "BubbleRed"
        case .bubbleYellow:   return "BubbleYellow"
        case .bubbleBlue:     return "BubbleBlue"
        case .bubbleOrange:   return "BubbleOrange"
        case .bubblePink:     return "BubblePink"
        case .bubbleGreen:    return "BubbleGreen"
        }
    }
}

// Used for colors that dont need saving
extension UIColor {
    struct Name: RawRepresentable {
        typealias RawValue = String

        var rawValue: RawValue

        var name: String { return rawValue}

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        init(name: String) {
            self.init(rawValue: name)
        }
    }

    convenience init?(named: Name) {
        self.init(named: named.name)
    }
}

extension UIColor.Name {
    static let appBackgroundColor       = UIColor.Name(name: "AppBackgroundColor")
    static let objectColor              = UIColor.Name(name: "ObjectColor")
    static let objectBorderColor        = UIColor.Name(name: "ObjectBorderColor")
    static let tintColor                = UIColor.Name(name: "TintColor")
}
