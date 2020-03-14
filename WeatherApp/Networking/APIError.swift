//
//  APIError.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/13/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unauthenticated
    case noResponse
    case jsonDecodingError(error: Error)
    case networkError(error: Error)
}
