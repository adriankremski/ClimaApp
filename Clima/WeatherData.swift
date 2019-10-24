//
//  WeatherData.swift
//  Clima
//
//  Created by Adrian Kremski on 17/10/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: MainWeatherData
    let weather: [Weather]
}

struct Weather : Decodable {
    let description: String
    let id: Int
}

struct MainWeatherData: Decodable {
    let temp: Double
}
