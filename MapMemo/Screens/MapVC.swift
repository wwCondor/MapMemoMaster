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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemYellow
        
//        mapView.delegate = self
        layoutUI()
    }
    
    override func  viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func layoutUI() {
        view.addSubviews(mapView)
        mapView.pinToEdges(of: view)
        
    }
}
