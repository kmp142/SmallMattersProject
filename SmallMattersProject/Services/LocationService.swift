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
    private var isUserLocationSetted: Bool = false

    @Published var userCurrentLocation: Location?

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            userCurrentLocation = Location(latitude: location.latitude, longitude: location.longitude)
            if !isUserLocationSetted, let location = userCurrentLocation {
                setAutoDetectedLocationOnLoggedInUser(location: location)
                isUserLocationSetted = true
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    private func setAutoDetectedLocationOnLoggedInUser(location: Location) {
        let userRepository = UserRepository(context: PersistentContainer.shared.viewContext)
        let user = userRepository.fetchLoggedInUser()
        if let user = user {
            user.locationLatitude = location.latitude
            user.locationLongitude = location.longitude
            userRepository.saveContext()
        }
    }
}
