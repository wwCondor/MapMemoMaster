//
//  NavigationVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 21/11/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit

class NavigationVC: UIViewController {
    
    var reminder: Reminder?
    
    private let locationManager          = LocationManager.shared
    
    private let mapView = MMMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureViewController()
        configureNavigationBar()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self

        //        locationManager.delegate = self
    }
    
    init(reminder: Reminder?) {
        super.init(nibName: nil, bundle: nil)
        self.reminder = reminder
        self.configureUI(for: reminder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: SFSymbols.back, style: .done, target: self, action:#selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func layoutUI() {
        view.addSubviews(mapView)
        mapView.pinToEdges(of: view)
        
//        NSLayoutConstraint.activate([
//
//
//        ])
    }
    
    private func configureUI(for reminder: Reminder?) {
        guard let reminder = reminder else {
            presentMMAlertOnMainThread(title: "Unable to update UI", message: MMError.unableToUpdateUI.localizedDescription, buttonTitle: "OK")
            return
        }
        
    }
    
    private func editLabels(for reminder: Reminder) {
        DispatchQueue.main.async {
            
        }
    }
    
    @objc private func backButtonTapped() {
         dismiss(animated: true)
     }
}

extension NavigationVC: LocationDataDelegate {
    func updateCurrentLocation(to location: CLLocation) {
        // In here we want to update user location on map
    }
    
    func updateCurrentHeading(to newHeading: CLHeading) {
        // In here we want to make sure that arrow around user location keeps indicating direction towards destination
    }
    
    
}

extension NavigationVC: MKMapViewDelegate {
    
    
//    private func prepareMapForDirections(from location: CLLocation, to destination: CLLocationCoordinate2D) {
//        let direction = MKDirections(request: createRequest(from: location, to: destination))
//        direction.calculate { [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//            for route in unwrappedResponse.routes {
//                self.mapView.addOverlay(route.polyline)
//                let padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: padding,animated: true)
//            }
//        }
//    }
    
}

