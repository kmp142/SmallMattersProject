//
//  MapViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 26.03.2024.
//

import Combine
import UIKit
import YandexMapsMobile

protocol MapViewModelInterface {
    func updateUserRealLocation()
    func updateCurrentSelectedLocation(with: YMKPoint)
    func setAddressCoordinatesByName(addressName: String)
    func setAddressNameByCoordinates(with: YMKPoint)
}

class MapViewModel: MapViewModelInterface {

    // Stores user location by phone geoposition
    @Published var userRealLocation: Coordinates?
    @Published var currentSelectedLocation: Coordinates?
    @Published var currentSelectedLocationAddress: String?
    lazy var searchManager = YandexMapsAddressSearchInteractor()

    func updateUserRealLocation() {
        LocationService.shared.$userCurrentLocation
            .compactMap{$0}
            .sink { [weak self] coordinates in
            self?.userRealLocation = coordinates
            self?.setAddressNameByCoordinates(with: YMKPoint(latitude: coordinates.latitude, longitude: coordinates.longitude))
        }.cancel()
    }

    init() {
        updateUserRealLocation()
    }

    func updateCurrentSelectedLocation(with: YMKPoint) {
        DispatchQueue.main.async { [weak self] in
            self?.currentSelectedLocation = Coordinates(latitude: with.latitude, longitude: with.longitude)
            self?.setAddressNameByCoordinates(with: with)
        }
    }

    func setAddressNameByCoordinates(with: YMKPoint) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchManager.searchAddressByCoordinates(latitude: with.latitude, longitude: with.longitude) { response in
                if !response.collection.children.isEmpty {
                    let searchResults = response.collection.children
                    if let mapObject = searchResults.first?.obj {
                        self.currentSelectedLocationAddress = mapObject.name ?? ""
                    }
                }
            }
        }
    }

    func setAddressCoordinatesByName(addressName: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.searchManager.searchAddressByString(addressName, completion: { response in
                if !response.collection.children.isEmpty {
                    let searchResults = response.collection.children
                    if let mapObject = searchResults.first?.obj {
                        self.currentSelectedLocationAddress = mapObject.name
                        if let point = mapObject.geometry.first?.point {
                            self.currentSelectedLocation = Coordinates(latitude: point.latitude, longitude: point.longitude)
                        }
                    }
                }
            })
        }
    }
}
