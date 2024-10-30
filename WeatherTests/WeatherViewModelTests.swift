//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Mani on 12/09/24.
//

import XCTest
import Combine
@testable import Weather

@MainActor
class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var mockImageCacheManager: MockImageCacheManager!
    var mockLocationManager: MockLocationManager!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockImageCacheManager = MockImageCacheManager()
        mockLocationManager = MockLocationManager()
        
        viewModel = WeatherViewModel(weatherService: mockWeatherService, imageCacheManager: mockImageCacheManager, locationManager: mockLocationManager)
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        mockImageCacheManager = nil
        mockLocationManager = nil
        super.tearDown()
    }
    
    // Test case 1: Test successful weather data fetching
    func testFetchWeatherSuccess() async {
        mockWeatherService.mockWeather = WeatherData(name: "Dallas", main: Main(temp: 25), weather: [
            Weather(description: "Clear", icon: "01d")
        ])
        
        await viewModel.fetchWeather()
        
        XCTAssertEqual(viewModel.temperature, "25.0 °C")
        XCTAssertEqual(viewModel.description, "Clear")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // Test case 2: Test fetch weather failure
    func testFetchWeatherFailure() async {
        mockWeatherService.shouldReturnError = true
        
        await viewModel.fetchWeather()
        
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch weather data.")
    }
    
    // Test case 3: Test icon loading from cache
    func testLoadIconFromCache() async {
        let cachedImage = UIImage(systemName: "sun.max")
        mockImageCacheManager.cachedImage = cachedImage
        
        await viewModel.loadIcon(iconName: "01d")
        
        XCTAssertEqual(viewModel.iconImage, cachedImage)
    }
    
    // Test case 4: Test icon loading from network
    func testLoadIconFromNetwork() async {
        mockImageCacheManager.cachedImage = nil
        
        await viewModel.loadIcon(iconName: "01d")
        
        XCTAssertNotNil(viewModel.iconImage)
    }
    
    // Test case 5: Test load from UserDefaults
    func testLoadWeatherFromUserDefaults() {
        let savedData = DefaultData(city: "San Francisco", temperature: "20 °C", description: "Sunny", iconName: "01d", iconImageData: nil)
        let encodedData = try! JSONEncoder().encode(savedData)
        UserDefaults.standard.set(encodedData, forKey: "weatherData")
        
        let viewModel = WeatherViewModel(weatherService: mockWeatherService, imageCacheManager: mockImageCacheManager, locationManager: mockLocationManager)
        
        XCTAssertEqual(viewModel.city, "San Francisco")
        XCTAssertEqual(viewModel.temperature, "20 °C")
        XCTAssertEqual(viewModel.description, "Sunny")
    }
}
