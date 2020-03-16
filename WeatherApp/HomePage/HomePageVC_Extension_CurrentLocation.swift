//
//  HomePageVC_Extension_CurrentLocation.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/15/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

//detecting current location
extension HomePageViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        guard let location = manager.location else { return }
        self.location = location
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            let placemark = placemarks?.last
            if let locality = placemark?.locality {
                self.currentLocation.city = locality
            } else if let name = placemark?.name, let country = placemark?.country {
                let location = Location(city: name, country: country)
               self.currentLocation = location
            }
        }
        
        stopLocationManager()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailwithError\(error)")
        stopLocationManager()
    }
    
    func stopLocationManager() {
       locationManager.stopUpdatingLocation()
       locationManager.delegate = nil
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
}

//saving the returned value and calling fetch data
extension HomePageViewController: SearchDelegate {
    func locationSelected(country: String) {
        self.currentLocation.country = country
        fetchData()
    }
}

//once the user presses on the search bar SearchViewController  will be pushed
extension HomePageViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyBoard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        searchVC.delegate = self
        self.searchBar.endEditing(true)
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
}
