//
//  HomePageTableViewCell.swift
//  WeatherApp
//
//  Created by Ali Rahal on 3/12/20.
//  Copyright © 2020 Ali Rahal. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.resetFields()
        // Initialization code
    }

    func resetFields() {
        self.weather.text = ""
        self.day.text = ""
        self.weatherType.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
