//
//  APICalls.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/7/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import Foundation

struct APICalls {
    
    static func fetchWeather(location: String, completionHandler: @escaping (CurrentWeatherForecastResponse?, APIError?) -> Void) {
        let request = APIService.shared.setupRequest(location: location, endoint: .weather)
        APIService.shared.GET(urlRequest: request) { (result: Result<CurrentWeatherForecastResponse, APIError>) in
            switch result {
            case let .success(response):
                completionHandler(response,nil)
            case let .failure(error):
                completionHandler(nil,error)
            }
        }
    }
    
    static func fetchForecast(location: String, completionHandler: @escaping (WeeklyForecastResponse?, APIError?) -> Void) {
        let request = APIService.shared.setupRequest(location: location, endoint: .forecast)
        APIService.shared.GET(urlRequest: request) { (result: Result<WeeklyForecastResponse, APIError>) in
            switch result {
            case let .success(response):
                completionHandler(response,nil)
            case let .failure(error):
                completionHandler(nil,error)
            }
        }
    }
}
