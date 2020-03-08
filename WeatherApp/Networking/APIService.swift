//
//  APIService.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/7/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import Foundation
import Combine

// MARK: - ErrorContainer
struct ErrorContainer: Codable {
    let errorContainer: ErrorContainerData
}

struct ErrorContainerData: Codable {
    let errorCode: Int
    let errorMessage: String
}

// MARK: - WeatherAPI
struct WeatherAPI {
   static let scheme = "https"
   static let host = "api.openweathermap.org"
   static let path = "/data/2.5"
   static let key = "86d085f39e357aaf1763bc00a1170d2a"
 }


struct APIService {
    let baseURL = URL(string: "api.openweathermap.org")!
    let apiKey = ""
    static let shared = APIService()
    let decoder = JSONDecoder()
    
    enum APIError: Error {
        case unauthenticated
        case noResponse
        case jsonDecodingError(error: Error)
        case networkError(error: Error)
    }
    
    enum Endpoint {
        case weather
        case forecast
        func path() -> String {
            switch self {
            case .weather:
                return "/weather"
            case .forecast:
                return "/forecast"
            }
        }
    }
    
    func setupComponents(endpoint: Endpoint, city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = WeatherAPI.scheme
        components.host = WeatherAPI.host
        components.path = WeatherAPI.path + endpoint.path()
        
        components.queryItems = [
          URLQueryItem(name: "q", value: city),
          URLQueryItem(name: "mode", value: "json"),
          URLQueryItem(name: "units", value: "metric"),
          URLQueryItem(name: "APPID", value: WeatherAPI.key)
        ]
        
        return components
    }
    
    func setupURL(components: URLComponents) -> URLRequest? {
        guard let url = components.url else {
            //handle
            return nil
        }
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let headers = ["Content-Type": "application/x-www-form-urlencoded",
                       "Accept-Encoding": "gzip,compress"]
        request.allHTTPHeaderFields = headers
        
        return request as URLRequest
    }
    
    func GET<T: Codable>(urlRequest: URLRequest,
    completionHandler: @escaping (Result<T, APIError>) -> Void){
        let task = URLSession.shared.dataTask(with: (urlRequest)) { (data, response, error) in
            guard let data = data else {
                completionHandler(.failure(.noResponse))
                return
            }
            guard error == nil else {
                completionHandler(.failure(.networkError(error: error!)))
                return
            }
            do {
                //handle business errors
                if let errorContainer = try? self.decoder.decode(ErrorContainer.self, from: data) {
                    print(errorContainer.errorContainer.errorMessage)
                    completionHandler(.failure(.unauthenticated))
                } else {
                    let object = try self.decoder.decode(T.self, from: data)
                    completionHandler(.success(object))
                }
            } catch let error {
                print(error)
                completionHandler(.failure(.jsonDecodingError(error: error)))
            }
        }
        task.resume()
    }
}
