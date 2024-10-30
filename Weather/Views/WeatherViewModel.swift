//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import Foundation
import Combine
import UIKit

/*
 * The ViewModel that is used along with the WeatherView.
 * This holds all the data the WeatherView has to render, handles the business logic, parsing
 * the data etc. It also handles the user defaults so as to retrieve the data from it when the
 * app renders.
 */
@MainActor
class WeatherViewModel: ObservableObject {
    //Below properties are published to the view based on the changes made.
    @Published var city: String = ""
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var iconImage: UIImage?
    @Published var errorMessage: String?
    
    // Private properties: Dependencies for the view view model to execute its functioanlity.
    private let weatherService: WeatherServiceProtocol  //Handles the api calls with weather server
    private let imageCacheManager: ImageCacheManagerProtocol //Handles the caching of the images so that it wont be fetched again
    private let locationManager: LocationManagerProtocol    //Handles the captuing of the location details of the user.
    private var cancellables: Set<AnyCancellable> = []
    private let userDefaults = UserDefaults.standard
    private let weatherDataKey = "weatherData"
    
    // Initializer with dependency injection
    // Initialize with all the necessary dependencies so as to perform its activities properly.
    init(weatherService: WeatherServiceProtocol, imageCacheManager: ImageCacheManagerProtocol, locationManager: LocationManagerProtocol) {
        self.weatherService = weatherService
        self.imageCacheManager = imageCacheManager
        self.locationManager = locationManager
        
        // Load weather data from UserDefaults or fetch weather based on location
        if let savedData = loadWeatherFromUserDefaults() {
            self.city = savedData.city
            self.temperature = savedData.temperature
            self.description = savedData.description
            if let imageData = savedData.iconImageData {
                self.iconImage = UIImage(data: imageData)
            }
        } else {
            subscribeToLocationUpdates()
        }
    }
    
    // Subscribe to location manager updates to fetch weather for the user's current city
    // Subscsribe only if there's no user defaults else it has to fetch the user location and
    // show the weather details of the location
    private func subscribeToLocationUpdates() {
        // Observe for the changes in the city.
        locationManager.currentCityPublisher
            .compactMap { $0 }
            .sink { [weak self] city in
                self?.city = city
                Task { await self?.fetchWeather() }
            }
            .store(in: &cancellables)
    }
    
    // Fetch weather for the current city
    func fetchWeather() async {
        guard !city.isEmpty else {
            errorMessage = "City cannot be empty."
            return
        }
        
        do {
            let weather = try await weatherService.fetchWeather(for: city)
            temperature = "\(weather.main.temp) °C"
            description = weather.weather.first?.description ?? "No description available."
            if let iconName = weather.weather.first?.icon {
                await loadIcon(iconName: iconName)
            }
            saveWeatherToUserDefaults(city: city, temperature: temperature, description: description, iconName: weather.weather.first?.icon)
        } catch {
            errorMessage = "Failed to fetch weather data."
        }
    }
    
    // Load weather icon, either from cache or network
    func loadIcon(iconName: String) async {
        if let cachedImage = imageCacheManager.getCachedImage(for: iconName) {
            iconImage = cachedImage
        } else {
            do {
                let image = try await weatherService.fetchWeatherIcon(for: iconName)
                imageCacheManager.cacheImage(image, for: iconName)
                iconImage = image
            } catch {
                errorMessage = "Failed to load weather icon."
            }
        }
    }
    
    // Save weather data to UserDefaults using WeatherData
    private func saveWeatherToUserDefaults(city: String, temperature: String, description: String, iconName: String?) {
        let iconImageData = iconImage?.pngData()
        let weatherData = DefaultData(
            city: city,
            temperature: temperature,
            description: description,
            iconName: iconName ?? "",
            iconImageData: iconImageData
        )
        
        if let encoded = try? JSONEncoder().encode(weatherData) {
            userDefaults.set(encoded, forKey: weatherDataKey)
        }
    }
    
    // Load weather data from UserDefaults using WeatherData
    private func loadWeatherFromUserDefaults() -> DefaultData? {
        if let savedWeatherData = userDefaults.data(forKey: weatherDataKey) {
            return try? JSONDecoder().decode(DefaultData.self, from: savedWeatherData)
        }
        return nil
    }
}
