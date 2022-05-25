//
//  WeatherManager.swift
//  WeatherNow
//
//  Created by Yash Mishra on 5/24/22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func updateWeather(_ weather: WeatherModel)
    func failureOccured(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1b646ba80f120f57e30b77ba6acce266&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(location: String) {
        let urlString = "\(weatherURL)&q=\(location)"
        performReq(urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performReq(urlString)
    }
    
    func performReq(_ urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, res, err) in
                if (err != nil) {
                    delegate?.failureOccured(error: err!)
                    return
                }
                
                if let safeData = data {
                    if let parsedWeatherData = parseJSON(safeData) {
                        delegate?.updateWeather(parsedWeatherData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let desc = decodedData.weather[0].description
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp, desc: desc)
        } catch {
            delegate?.failureOccured(error: error)
            return nil
        }
    }
}
