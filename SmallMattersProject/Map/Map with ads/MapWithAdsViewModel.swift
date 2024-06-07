//
//  ClusterizedMapViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 27.03.2024.
//

import Foundation
import YandexMapsMobile
import Combine

protocol MapWithAdsViewModelInterface {
    func updateAds()
    func calculateDistanceFromUserToAd(ad: Ad, completion: @escaping ((Double) -> Void))
    func getSelectedAdAddressName(location: Location, completion: @escaping (String) -> Void)
    func getSelectedAdAuthor() async -> User?
}

class MapWithAdsViewModel: MapWithAdsViewModelInterface {

    @Published var ads: [Ad] = []
    @Published var selectedAd: Ad?
    private var selectesAdAddressName: String?
    @Published var userLocation: Location?
    let routeBuilder = YRouteBuilder()
    let addressSearchInteractor = YandexMapsAddressSearchInteractor()
    private var userLocationSubcription: AnyCancellable?
    let networkService: NetworkServiceInterface?

    init (networkService: NetworkServiceInterface) {
        self.networkService = networkService
        updateAds()
    }

    func updateAds() {
        Task {
            let ads = try await networkService?.fetchActiveAdsFromServer()
            self.ads = ads ?? []
        }
    }

    func calculateDistanceFromUserToAd(ad: Ad, completion: @escaping ((Double) -> Void)) {

        guard let userLocation = userLocation else { return }

        let userPoint = YMKRequestPoint(point: YMKPoint(latitude: userLocation.latitude, longitude: userLocation.longitude), type: .waypoint, pointContext: nil, drivingArrivalPointId: nil)

        let adPoint = YMKRequestPoint(point: YMKPoint(latitude: ad.locationLatitude, longitude: ad.locationLongitude), type: .waypoint, pointContext: nil, drivingArrivalPointId: nil)

        routeBuilder.calculateDistance(from: userPoint, to: adPoint){ routes, error in
            if let distanceToAd = routes?.first?.weight.distance.value {
                completion(distanceToAd)
            }
        }
    }

    //TODO: - Error handling
    func getSelectedAdAddressName(location: Location, completion: @escaping (String) -> Void) {
        addressSearchInteractor.searchAddressByCoordinates(latitude: location.latitude, longitude: location.longitude) { response, error in
            guard let response = response, let name = response.collection.children.first?.obj?.name else { return }
            completion(name)
            if let _ = error {

            }
        }
    }

    func getSelectedAdAuthor() async -> User? {

        guard let selectedAd = selectedAd else { return nil }

        if let networkService = networkService {
            return try? await networkService.fetchUserById(id: selectedAd.authorId)
        } else {
            return nil
        }
    }
}
