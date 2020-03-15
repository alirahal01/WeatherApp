//
//  HomePageViewModel.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/13/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import Foundation
import UIKit

class HomePageViewModel: NSObject {
    
    var currentWeatherDataSource: CurrentWeatherForecastResponse!
    var weeklyForecastDataSource: WeeklyResponse!
    var currentWeatherRespose: (CurrentWeatherForecastResponse?, APIError?)!
    var WeeklyForecastResponse: (WeeklyForecastResponse?, APIError?)!
    
    
    func fetchCurrentWeather(location: String, completionHandler: @escaping (Bool) -> ()) {
        APICalls.fetchWeather(location: location) { (response, error) in
            self.currentWeatherRespose = (response,error)
            completionHandler(true)
        }
    }
    
    func fetchForecastedWeather(location: String, completionHandler: @escaping (Bool) -> ()) {
        APICalls.fetchForecast(location: location) { (response, error) in
            self.WeeklyForecastResponse = (response,error)
            completionHandler(true)
        }
    }
}

