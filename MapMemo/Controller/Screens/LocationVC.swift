//
//  LocationVC.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 20/02/2020.
//  Copyright © 2020 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit

protocol LocationDelegate: class {
    func locationSelected(title: String, subtitle: String, latitude: Double, longitude: Double)
}

class LocationVC: UIViewController {
    
    weak var delegate: LocationDelegate!
    
    private let locationSearchBar       = MMLocationSearchBar()
    private let searchResultsTableView  = UITableView()
    private let searchCompleter         = MKLocalSearchCompleter()
    private let cellId                  = "searchResultsId"

    var searchResults                   = [MKLocalSearchCompletion]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        layoutUI()
        configureNavigationBar()
        configureSearchResultsTableView()
        setDelegates()
        
        locationSearchBar.becomeFirstResponder()
    }
    
    private func layoutUI() {
        view.addSubviews(locationSearchBar, searchResultsTableView)
        
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            locationSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            locationSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            locationSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            locationSearchBar.heightAnchor.constraint(equalToConstant: 60),
            
            searchResultsTableView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func configureNavigationBar() {
        let backButtton = UIBarButtonItem(image: SFSymbols.back, style: .done, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtton
    }

    private func configureSearchResultsTableView() {
        searchResultsTableView.backgroundColor = UIColor.clear
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setDelegates() {
        locationSearchBar.delegate = self
        searchCompleter.delegate = self
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension LocationVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension LocationVC: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadDataOnMainThread()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        presentMMAlertOnMainThread(title: "No Results", message: MMError.noResults.localizedDescription, buttonTitle: "OK")
        // This alert currently also triggers when user empties search field 
    }
}

extension LocationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell                        = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle             = .none
        cell.textLabel?.text            = searchResult.title
        cell.detailTextLabel?.text      = searchResult.subtitle
        cell.textLabel?.textColor       = .systemPink
        cell.detailTextLabel?.textColor = .systemPink
        cell.backgroundColor            = .systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (result, error) in
            guard let location = result?.mapItems.last?.placemark else {
                self.presentMMAlertOnMainThread(title: "Location Error", message: MMError.noLocation.localizedDescription, buttonTitle: "OK")
                return
            }

            let latitude      = location.coordinate.latitude as Double
            let longitude     = location.coordinate.longitude as Double
            
            guard let locationName    = location.name else { return }
            guard let streetAddress   = location.thoroughfare, let streetNumber = location.subThoroughfare else { return }
            guard let city            = location.locality else { return }
            guard let isoCountryCode  = location.isoCountryCode else { return }
            
            let locationTitle    = locationName
            var locationSubtitle = ""
            
            if "\(locationName)" == "\(streetAddress) \(streetNumber)" {
                locationSubtitle = "\(city) (\(isoCountryCode))"
            } else {
                locationSubtitle = "\(streetAddress) \(streetNumber), \(city) (\(isoCountryCode))"
            }
            
            self.delegate.locationSelected(title: locationTitle, subtitle: locationSubtitle, latitude: latitude, longitude: longitude)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
