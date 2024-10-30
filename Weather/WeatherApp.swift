//
//  WeatherApp.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import SwiftUI

@main
//This is the entry point of the application.
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            let coordinator = HomeCoordinator()
            coordinator.start()
        }
    }
}
