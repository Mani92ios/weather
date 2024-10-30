//
//  WeatherData.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import Foundation

//For time being, i captured all the models into one file.
//As they are associated with each other, its good to have them in one file.

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
    let icon: String
}
