//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/7/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet weak var dateValue: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherValue: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    var result : CurrentWeatherForecastResponse!
    override func viewDidLoad() {
        super.viewDidLoad()

        let components = APIService.shared.setupComponents(endpoint: .weather, city: "Beirut")
        let request = APIService.shared.setupURL(components: components) as! URLRequest
        APIService.shared.GET(urlRequest: request) {  (result: Result<CurrentWeatherForecastResponse, APIService.APIError>) in
            switch result {
            case let .success(response):
                self.setupValues(response: response)
                print(response)
            case .failure(_):
                break
            }
        }
        // Do any additional setup after loading the view.
    }


    func setupValues(response: CurrentWeatherForecastResponse) {
        DispatchQueue.main.async {
            self.cityName.text = "Beirut"
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let now = df.string(from: Date())
            self.dateValue.text = now
            self.weatherValue.text = "\(Int(response.main.temperature))"
        }

    }
}

