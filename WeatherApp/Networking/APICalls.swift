//
//  APICalls.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/7/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import Foundation

struct APICalls {
    
    static func fetchWeather() {
        let components = APIService.shared.setupComponents(endpoint: .weather, city: "Beirut")
        let request = APIService.shared.setupURL(components: components) as! URLRequest
        APIService.shared.GET(urlRequest: request) {  (result: Result<CurrentWeatherForecastResponse, APIService.APIError>) in
            switch result {
            case let .success(response):
                print(response)
            case .failure(_):
                break
            }
        }
    }
    
    static func fetchForecast() {
       let components = APIService.shared.setupComponents(endpoint: .forecast, city: "Beirut")
        let request = APIService.shared.setupURL(components: components) as! URLRequest
        APIService.shared.GET(urlRequest: request) {  (result: Result<WeeklyForecastResponse, APIService.APIError>) in
            switch result {
            case let .success(response):
                print(response)
            case .failure(_):
                break
            }
        }
    }
}
