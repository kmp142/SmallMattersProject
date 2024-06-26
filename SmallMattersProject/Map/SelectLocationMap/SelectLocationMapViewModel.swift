//
//  MapViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 26.03.2024.
//

import Combine
import UIKit
import YandexMapsMobile

protocol SelectLocationMapViewModelInterface {
    func updateActiveUserLocation()
    func updateCurrentSelectedLocation(with: YMKPoint)
    func setAddressCoordinatesByName(addressName: String)
    func setAddressNameByCoordinates(with: YMKPoint)
    func saveSelectedLocation()

    var activeUserLocation: Location? { get }
    var activeUserLocationPublished: Published<Location?>.Publisher { get }

    var currentSelectedLocation: Location? { get }
    var currentSelectedLocationPublisher: Published<Location?>.Publisher { get }

    var currentSelectedLocationAddress: String? { get }
    var currentSelectedLocationAddressPublisher: Published<String?>.Publisher { get }
}

class MapViewModel: SelectLocationMapViewModelInterface {

    //MARK: - Properties

    // Stores user location by phone geoposition
    @Published var activeUserLocation: Location?
    var activeUserLocationPublished: Published<Location?>.Publisher { $activeUserLocation }

    @Published var currentSelectedLocation: Location?
    var currentSelectedLocationPublisher: Published<Location?>.Publisher { $currentSelectedLocation }

    @Published var currentSelectedLocationAddress: String?
    var currentSelectedLocationAddressPublisher: Published<String?>.Publisher { $currentSelectedLocationAddress }
    
    private lazy var searchManager = YandexMapsAddressSearchInteractor()

    init() {
        updateActiveUserLocation()
    }

    //MARK: Location

    func updateActiveUserLocation() {
        let user = AuthManager.shared.activeUser

        if let user = user {
            self.activeUserLocation = Location(latitude: user.locationLatitude, longitude: user.locationLongitude)
            self.setAddressNameByCoordinates(with: YMKPoint(latitude: user.locationLatitude, longitude: user.locationLongitude))
        } else {
            LocationService.shared.$userCurrentLocation
                .compactMap{$0}
                .sink { [weak self] coordinates in
                self?.activeUserLocation = coordinates
                self?.setAddressNameByCoordinates(with: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
            }.cancel()
        }

    }

    func updateCurrentSelectedLocation(with: YMKPoint) {
        DispatchQueue.main.async { [weak self] in
            self?.currentSelectedLocation = Location(latitude: with.latitude, longitude: with.longitude)
            self?.setAddressNameByCoordinates(with: with)
        }
    }

    //TODO: Error handling
    func setAddressNameByCoordinates(with: YMKPoint) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchManager.searchAddressByCoordinates(latitude: with.latitude, longitude: with.longitude) { response, error in
                if let response = response, !response.collection.children.isEmpty {
                    let searchResults = response.collection.children
                    if let mapObject = searchResults.first?.obj {
                        self.currentSelectedLocationAddress = mapObject.name ?? ""
                    }
                }
                if let _ = error {
                    
                }
            }
        }
    }

    func setAddressCoordinatesByName(addressName: String) {
        self.searchManager.searchAddressByString(addressName, completion: { response in
            guard !response.collection.children.isEmpty else { return }
            if let mapObject = response.collection.children.first?.obj {
                self.currentSelectedLocationAddress = mapObject.name
                if let point = mapObject.geometry.first?.point {
                    self.currentSelectedLocation = Location(latitude: point.latitude, longitude: point.longitude)
                }
            }
        })
    }

    func saveSelectedLocation() {
        DispatchQueue.main.async {
            let user = AuthManager.shared.activeUser
            if let user = user, let currentLocation = self.currentSelectedLocation {
                user.locationLatitude = currentLocation.latitude
                user.locationLongitude = currentLocation.longitude
                PersistentContainer.shared.saveContext()
            }
        }
    }
}
