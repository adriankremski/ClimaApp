//
//  WeatherManager.swift
//  Clima
//
//  Created by Adrian Kremski on 17/10/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=e72ca729af228beabd5d20e3b7749713&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)".replacingOccurrences(of: " ", with: "%20")
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
         let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
         performRequest(with: urlString)
     }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
    
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                   
                if let safeData = data {
                    if let weather = self.parseJson(weatherData: safeData) {
                        self.delegate?.didUpdateWeahter(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }

    func parseJson(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let parsedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = parsedData.weather[0].id
            let temp = parsedData.main.temp
            let name = parsedData.name
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

protocol WeatherManagerDelegate {
    func didUpdateWeahter(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
