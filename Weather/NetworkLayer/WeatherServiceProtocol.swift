//
//  WeatherServiceProtocol.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import Foundation
import UIKit

//Inteface for handling the APIs
protocol WeatherServiceProtocol {
    //Method for fetching the weather based on the city
    func fetchWeather(for city: String) async throws -> WeatherData
    //Method for fetching the icon's image if its not cached already
    func fetchWeatherIcon(for iconName: String) async throws -> UIImage
}
