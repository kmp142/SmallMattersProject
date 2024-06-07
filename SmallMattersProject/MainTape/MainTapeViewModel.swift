//
//  MainTapeViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 01.04.2024.
//

import Foundation
import YandexMapsMobile
import Combine

protocol MainTapeViewModelInterface {
    func updateAllAds()
    func fetchActiveUserLocation()
    func filterAds()
    func fetchAuthorForAd(ad: Ad) -> User?
}

class MainTapeViewModel: MainTapeViewModelInterface {

    

    @Published var adsWithUsers: [Ad:User] = [:]
    private var userLocationLatitude: Double?
    private var userLocationLongitude: Double?
    private let networkService: NetworkServiceInterface?
    private var subscriptionOnLocationService: AnyCancellable?
    @Published var locationAddressName: String?
    private var searchInteractor: SearchInteractor?
    var adsBountyRange: ClosedRange<Double>?
    var adsDistanceToUserRange: ClosedRange<Double>?
    var hoursToDeadline: ClosedRange<Int>?

    init(networkService: NetworkServiceInterface, searchInteractor: SearchInteractor) {
        self.networkService = networkService
        self.searchInteractor = searchInteractor
        updateAllAds()
        if let _ = AuthManager.shared.activeUser {
            fetchActiveUserLocation()
        } else {
            subscribeOnLocationService()
        }
    }

    func updateAllAds() {

        Task {
            let receivedAds = try await self.networkService?.fetchActiveAdsFromServer()
            if let ads = receivedAds {
                adsWithUsers = [:]
                await withTaskGroup(of: (Ad, User?).self) { group in

                    for ad in ads {
                        group.addTask {
                            let user = await self.fetchAuthorForAdFromServer(id: ad.authorId)
                            return (ad, user)
                        }
                    }

                    for await (ad, user) in group {
                        if let user = user {
                            adsWithUsers[ad] = user
                        }
                    }
                }
            }
        }

        let context = PersistentContainer.shared.viewContext
        let adRepository = AdRepository<Ad>(context: context)

        let ads = adRepository.fetchAllFromCoreData()
        for aa in ads {
            print(aa.deadline)
        }

    }


    func fetchAuthorForAdFromServer(id: String) async -> User? {
        do {
            let user = try await networkService?.fetchUserById(id: id)
            return user
        } catch {
            return nil
        }
    }

    func fetchActiveUserLocation() {

        let user = AuthManager.shared.activeUser

        if let user = user {
            self.userLocationLatitude = user.locationLatitude
            self.userLocationLongitude = user.locationLongitude
            self.searchAddressNameByCoordinates(latitude: user.locationLatitude, longitude: user.locationLongitude){ addressName in
                self.locationAddressName = addressName
                user.addressName = addressName
            }
            self.subscriptionOnLocationService = nil
        }
    }

    func fetchAuthorForAd(ad: Ad) -> User? {
        return adsWithUsers[ad]
    }

    private func subscribeOnLocationService() {
        subscriptionOnLocationService = LocationService.shared
            .$userCurrentLocation
            .compactMap { $0 }
            .sink(receiveValue: { [weak self] location in
                guard let self = self else { return }
                self.userLocationLatitude = location.latitude
                self.userLocationLongitude = location.longitude
                self.searchAddressNameByCoordinates(latitude: location.latitude, longitude: location.longitude) { addressName in
                    if let addressName = addressName {
                        self.locationAddressName = addressName
                    }
                }
        })
    }

    private func searchAddressNameByCoordinates(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void){

        self.searchInteractor?.searchAddressByCoordinates(latitude: latitude, longitude: longitude, completion: { response, error in
            if let response = response, !response.collection.children.isEmpty {
                let searchResults = response.collection.children
                if let mapObject = searchResults.first?.obj {
                    completion(mapObject.name)
                }
            }
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
        })
    }

    func filterAds() {
        if let bounty = adsBountyRange, let distance = adsDistanceToUserRange, let deadline = hoursToDeadline {
            var ads = Array(adsWithUsers.keys)
            ads = ads.filter {
                let now = Date.now
                let adDeadline = $0.deadline
                let hoursToDeadline = Int(adDeadline.timeIntervalSince(now) / 3600)
                if bounty.contains($0.bounty), distance.contains($0.distanceToUser),
                   deadline.contains(hoursToDeadline) {
                    return true
                }
                return false
            }
            if ads.isEmpty {
                adsWithUsers = [:]
            } else {
                ads.forEach { [weak self] in
                    if self?.adsWithUsers.keys.contains($0) == false {
                        self?.adsWithUsers.removeValue(forKey: $0)
                    }
                }
            }
        }
    }
}
