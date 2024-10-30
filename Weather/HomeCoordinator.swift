//
//  HomeCoordinator.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import SwiftUI

class HomeCoordinator {
    @MainActor 
    /*
     * Start the coordinator by creating the initial view.
     * We are using WeatherView as the entry screen.
     * All the dependencies for this view are created and injected into the view model.
     * There by creating the view with the view model as part of the MVVM.
     */
    func start() -> some View {
        let weatherService = OpenWeatherService()
        let imageCacheManager = ImageCacheManager()
        let locationManager = LocationManager()
        
        let viewModel = WeatherViewModel(weatherService: weatherService, imageCacheManager: imageCacheManager, locationManager: locationManager)
        return WeatherView(viewModel: viewModel)
    }
}
