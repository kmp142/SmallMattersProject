//
//  AddAdViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 27.05.2024.
//

import Foundation
import YandexMapsMobile
import Combine

protocol AddAdViewModelInterface {
    func publicAd(title: String, description: String, deadline: Date, minimalExecutorRating: Int, bounty: Double) async
}

class AddAdViewModel: AddAdViewModelInterface {

    //MARK: - Properties

    @Published var activeUserLocation: Location?
    var activeUserLocationPublished: Published<Location?>.Publisher { $activeUserLocation }
    private lazy var searchManager = YandexMapsAddressSearchInteractor()

    @Published var currentSelectedLocation: Location?
    var currentSelectedLocationPublisher: Published<Location?>.Publisher { $currentSelectedLocation }

    @Published var currentSelectedLocationAddress: String?
    var currentSelectedLocationAddressPublisher: Published<String?>.Publisher { $currentSelectedLocationAddress }

    private var adAddressName: String?
    private var adAddressLocation: Location?

    private var networkService: NetworkServiceInterface?
    weak var view: AddAdVCInterface?

    private var activeUser: User?

    //MARK: - Initialization

    init(activeUser: User?, activeUserLocation: Location, networkService: NetworkServiceInterface) {
        self.activeUser = activeUser
        self.activeUserLocation = activeUserLocation
        self.networkService = networkService
    }
}

extension AddAdViewModel: SelectLocationMapViewModelInterface {
    
    func updateActiveUserLocation() {

        if let user = activeUser {
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
        view?.setAddressName(addressName: currentSelectedLocationAddress)
    }


    //MARK: - Interface implementation

    func publicAd(title: String, description: String, deadline: Date, minimalExecutorRating: Int, bounty: Double) async {
          if let user = activeUser {
            let context = PersistentContainer.shared.viewContext
            let ad = Ad(context: context)
            ad.distanceToUser = Double.random(in: 200...1000)

            if let latitude = currentSelectedLocation?.latitude, let longitude = currentSelectedLocation?.longitude {
                ad.locationLatitude = latitude
                ad.locationLongitude = longitude
            } else {
                ad.locationLatitude = user.locationLatitude
                ad.locationLongitude = user.locationLongitude
            }

            ad.deadline = deadline
            ad.bounty = bounty
            ad.authorId = user.id
            ad.title = title
            ad.adDescription = description
            ad.id = "\(Int.random(in: 100...10000))"
            ad.executorId = nil
            ad.state = "active"
            ad.minimalExecutorRating = Int16(minimalExecutorRating)
              Task {
                  try await networkService?.publicAd(ad)
              }
        }
    }
}
