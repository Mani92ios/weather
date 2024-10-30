//
//  MockServices.swift
//  WeatherTests
//
//  Created by Mani on 12/09/24.
//

import XCTest
import Combine
@testable import Weather

class MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError = false
    var mockWeather: WeatherData?

    func fetchWeather(for city: String) async throws -> WeatherData {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return mockWeather ?? WeatherData(name: "Dallas", main: Main(temp: 25), weather: [
            Weather(description: "Clear", icon: "01d")
        ])
    }
    
    func fetchWeatherIcon(for iconName: String) async throws -> UIImage {
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        return UIImage(systemName: "sun.max")!
    }
}

class MockImageCacheManager: ImageCacheManagerProtocol {
    var cachedImage: UIImage?
    
    func getCachedImage(for iconName: String) -> UIImage? {
        return cachedImage
    }
    
    func cacheImage(_ image: UIImage, for iconName: String) {
        cachedImage = image
    }
}

class MockLocationManager: LocationManagerProtocol {
    var currentCity: String?
    
    var currentCityPublisher: AnyPublisher<String?, Never> {
        Just("San Francisco").eraseToAnyPublisher()
    }
}
