//
//  LocationManager.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, LocationManagerProtocol {
    // Published property for the current city
    @Published var currentCity: String?
    
    // CLLocationManager instance for location services
    private let locationManager = CLLocationManager()
    private var cancellables: Set<AnyCancellable> = []
    
    //Initilize the delegates and accuracy.
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //For time being, i'm requesting the permission every time, else we have to wait for the authorization and then ask the location permission accordingly
        requestLocationPermission()
    }
    
    // The current city publisher which other classes can subscribe to
    var currentCityPublisher: AnyPublisher<String?, Never> {
        $currentCity.eraseToAnyPublisher()
    }
    
    // Request user authorization for location services
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        //IF the permission is enabled, then start capturing the user location.
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    // Delegate method for location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        reverseGeocode(location)
        locationManager.stopUpdatingLocation()  // Stop updating to conserve battery
    }
    
    // Reverse geocode the coordinates to obtain the city name
    private func reverseGeocode(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            DispatchQueue.main.async {
                self?.currentCity = placemark.locality  // Assign the city name
            }
        }
    }
    
    // Handle authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            // Handle unauthorized case (e.g., show a message to the user)
            currentCity = nil
        }
    }
    
    // Handle location update failure
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
        currentCity = nil
    }
}
