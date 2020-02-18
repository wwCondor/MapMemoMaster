//
//  MMLocationSearchBar.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit

class MMLocationSearchBar: UISearchBar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        addBorders(edges: [.top, .bottom])
        placeholder                 = "Search location"
        barTintColor                = .systemBackground
        tintColor                   = .systemPink
        searchTextField.textColor   = .systemPink
        searchTextField.font        = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    }
}
