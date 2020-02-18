//
//  MapVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 18/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    private let mapView = MMMapView()
    private let compassBackgroundView = MMBackgroundView(backgroundColor: .systemBackground, cornerRadius: Configuration.compassBackgroundSize/2)
    private let compass = MMCompassImageView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        
//        mapView.delegate = self
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func layoutUI() {
        view.addSubviews(mapView, compassBackgroundView, compass)
        mapView.pinToEdges(of: view)
        
        let padding: CGFloat = 30
        
        NSLayoutConstraint.activate([
            compassBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            compassBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            compassBackgroundView.widthAnchor.constraint(equalToConstant: Configuration.compassBackgroundSize),
            compassBackgroundView.heightAnchor.constraint(equalToConstant: Configuration.compassBackgroundSize),
            
            compass.centerXAnchor.constraint(equalTo: compassBackgroundView.centerXAnchor),
            compass.centerYAnchor.constraint(equalTo: compassBackgroundView.centerYAnchor),
            compass.widthAnchor.constraint(equalToConstant: Configuration.compassSize),
            compass.heightAnchor.constraint(equalToConstant: Configuration.compassSize),
        ])
    }
}
