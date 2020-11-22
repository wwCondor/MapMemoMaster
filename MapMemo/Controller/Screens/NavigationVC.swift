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
    
    private let mapView     = MMMapView()
    private let backButton  = MMImageView(image: SFSymbols.back!, tintColor: .systemPink)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
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
        layoutUI()
//        addGestureRecognizers()
        
        mapView.delegate = self
        mapView.showsUserLocation  = true
    }
    
    private func layoutUI() {
        view.addSubviews(mapView)//, backButton)
        mapView.pinToEdges(of: view)
        
//        let padding: CGFloat = 30
//
//        NSLayoutConstraint.activate([
//            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
//            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            backButton.widthAnchor.constraint(equalToConstant: Configuration.backButtonSize),
//            backButton.heightAnchor.constraint(equalToConstant: Configuration.backButtonSize),
//        ])
    }
    

    
//    private func addGestureRecognizers() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
//        backButton.addGestureRecognizer(tapGesture)
//    }
    
    private func configureUI(for reminder: Reminder?) {
        guard let reminder = reminder else {
            presentMMAlertOnMainThread(title: "Unable to update UI", message: MMError.unableToUpdateUI.localizedDescription, buttonTitle: "OK")
            return
        }
        createAnnotation(for: reminder)
        configureNavigationBar(for: reminder)
    }

    private func createAnnotation(for reminder: Reminder) {
        let annotation          = MMPointAnnotation()
        annotation.title        = reminder.identifier
        annotation.subtitle     = reminder.message
        annotation.pinTintColor = reminder.isActive ? UIColor.systemPink : UIColor.white
        annotation.coordinate   = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
        mapView.addAnnotation(annotation)
    }
    
    private func configureNavigationBar(for reminder: Reminder) {
        DispatchQueue.main.async {
            let backButton = UIBarButtonItem(image: SFSymbols.back, style: .done, target: self, action:#selector(self.backButtonTapped))
            self.navigationController?.navigationBar.barTintColor = .systemBackground
            self.navigationItem.leftBarButtonItem = backButton
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemPink]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
            self.navigationItem.title = reminder.locationName
        }
    }
    
    private func drawRouteOnMap(from location: CLLocation, to destination: CLLocationCoordinate2D) {
        let directions = MKDirections(request: createDirectionsRequest(from: location, to: destination))
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                let padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: padding,animated: true)
            }
        }
    }
    
    private func createDirectionsRequest(from location: CLLocation, to destination: CLLocationCoordinate2D) -> MKDirections.Request {
        let request = MKDirections.Request()
        let currentCoordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: currentCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.requestsAlternateRoutes = false // Set to true for multiple routes
        request.transportType = .automobile
        return request
    }
    
//    private func configureTitle(for reminder: Reminder) {
//        DispatchQueue.main.async { self.navigationItem.title = reminder.locationName }
//    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
//    @objc private func backButtonTapped(sender: MMImageView) {
//        print("Backbutton Tapped")
//        dismiss(animated: true)
//    }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "AnnotationId"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        if let annotation = annotation as? MMPointAnnotation {
            annotationView?.pinTintColor = annotation.pinTintColor
        }
        
        return annotationView
    }
}

