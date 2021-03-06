//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/7/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import UIKit
import CoreLocation

struct Location {
    var city: String
    var country: String
}

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let unWrappedDataSource = self.result2 {
            return unWrappedDataSource.list.count
        } else {
            return 0
        }
    }
    
    
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherValue: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var result1 : CurrentWeatherForecastResponse!
    var result2 : WeeklyForecastResponse!
    var viewModel: HomePageViewModel!
    
    
    let locationManager = CLLocationManager()
    var location: CLLocation?
    let geocoder = CLGeocoder()
    var currentLocation: Location! {
        didSet {
            fetchData()
        }
    }
    fileprivate func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HomePageTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func resetValues() {
        self.weatherType.text = ""
        self.dateValue.text = ""
        self.cityName.text = ""
        self.weatherValue.text = ""
    }
    
    func setupLocationManager() {
        
        let authStatus = CLLocationManager.authorizationStatus()
         if authStatus == .notDetermined {
             locationManager.requestWhenInUseAuthorization()
         }

         if authStatus == .denied || authStatus == .restricted {
             //add alert
         }
        startLocationManager()
    }
    
    func fetchData() {
        viewModel.fetchCurrentWeather(location: self.currentLocation.country) { (isDone) in
            if let error1 = self.viewModel.currentWeatherRespose.1 {
                
                
            } else {
                self.result1 = self.viewModel.currentWeatherRespose.0
                self.setupValues()
            }
            
        }
        
        viewModel.fetchForecastedWeather(location: self.currentLocation.country) { (isDone) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            
            if let error2 = self.viewModel.WeeklyForecastResponse.1 {
                
            } else {
                self.result2 = self.viewModel.WeeklyForecastResponse.0
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.searchBar.delegate = self
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .white
        searchBar.isTranslucent = false
        super.viewDidLoad()
        self.setupLocationManager()
        self.resetValues()
        self.setupTableView()
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
        self.viewModel = HomePageViewModel()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func setupValues() {
        DispatchQueue.main.async {
            self.cityName.text = self.currentLocation.country
            let df = DateFormatter()
            df.dateFormat = "EEEE, MMM dd"
            let now = df.string(from: Date())
            self.weatherType.text = "Humidity " + "\(self.result1.main.humidity)"
            self.dateValue.text = now
            self.weatherValue.text = "\(Int(self.result1.main.temperature))"
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HomePageTableViewCell else { return UITableViewCell() }
        let list = self.result2.list
        let item = list[indexPath.row]
        cell.weather.text = "\(Int(item.main.temp))"
        cell.weatherType.text = item.weather.first?.weatherDescription
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM dd"
        cell.day.text = df.string(from: item.date)
        return cell
    }
}

