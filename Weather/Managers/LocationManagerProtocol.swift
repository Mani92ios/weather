//
//  LocationManagerProtocol.swift
//  Weather
//
//  Created by Mani on 13/09/24.
//

import Combine

// Interface for the location manager.
// We need the current city and changes to the city must be published
protocol LocationManagerProtocol {
    var currentCityPublisher: AnyPublisher<String?, Never> { get }
    var currentCity: String? { get set }
}
