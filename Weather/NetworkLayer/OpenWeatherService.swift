//
//  OpenWeatherService.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import Foundation
import UIKit

class OpenWeatherService: WeatherServiceProtocol {
    //We can maintain a conmstants file but for time being i am hardcoding the strings here.
    private let apiKey = "c4a0c4cd3706a7fc9dee0176eaf027c7"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    private let imageBaseUrl = "https://openweathermap.org/img/wn/"
    
    //Calling weather api to fetch the details of the weather.
    //ITs an async method. It awaits for the response to come and returns the parsed data.
    //It also handles the errors gracefully and throw them accordingly
    func fetchWeather(for city: String) async throws -> WeatherData {
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric"
        
        // Ensure URL is valid
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // Fetch data from the API
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode the JSON response
        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
        
        return weatherData
    }
    
    //Mtehod to fetch the icon and then returns the image.
    //If there's an error, it will throw the error accordingly
    func fetchWeatherIcon(for iconName: String) async throws -> UIImage {
        let urlString = "\(imageBaseUrl)/\(iconName)@2x.png"
        
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid Icon URL", code: -1, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "Invalid Image Data", code: -1, userInfo: nil)
        }
        
        return image
    }
}
