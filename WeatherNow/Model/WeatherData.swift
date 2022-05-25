//
//  WeatherData.swift
//  WeatherNow
// Models the JSON Data that comes from the API request
//  Created by Yash Mishra on 5/24/22.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}
