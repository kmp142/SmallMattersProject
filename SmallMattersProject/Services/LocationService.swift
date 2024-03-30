//
//  LocationManager.swift
//  SmallMattersProject
//
//  Created by Dmitry on 25.03.2024.
//

import Foundation
import CoreLocation
import Combine

class LocationService: NSObject, CLLocationManagerDelegate {

    static let shared = LocationService()
    private var locationManager = CLLocationManager()

    @Published var userCurrentLocation: Coordinates?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.first?.coordinate {
            userCurrentLocation = Coordinates(latitude: coordinates.latitude, longitude: coordinates.longitude)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
