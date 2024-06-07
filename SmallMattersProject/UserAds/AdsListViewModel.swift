//
//  AdsListViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 06.05.2024.
//

import Foundation
import Combine

protocol AdsListViewModelInterface {
    func updatePublishedAds()
    func updateRespondedAds()
    func fetchAuthorForAd(ad: Ad) -> User?
}

class AdsListViewModel: AdsListViewModelInterface {
    
    private var networkService: NetworkServiceInterface?
    private var activeUser: User?

    private var subscripitions = Set<AnyCancellable>()

    var publishedAdsWithUsers: [Ad:User] = [:]
    var respondedAdsWithUsers: [Ad:User] = [:]

    weak var view: AdsListViewControllerInterface?

    init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
        subscribeOnActiveUser()
    }

    func updatePublishedAds() {
        if let user = activeUser {
            Task {
                let publishedAds = try await networkService?.fetchPublishedAdsByUserId(id: user.id)

                if let ads = publishedAds {
                    await withTaskGroup(of: (Ad, User?).self) { group in

                        for ad in ads {
                            group.addTask {
                                let user = await self.fetchAuthorForAdFromServer(id: user.id)
                                return (ad, user)
                            }
                        }

                        for await (ad, user) in group {
                            if let user = user {
                                publishedAdsWithUsers.updateValue(user, forKey: ad)
                            }
                        }
                        view?.updateDataSource(with: publishedAds ?? [])
                    }
                }
            }
        } else {
            publishedAdsWithUsers = [:]
        }
    }

    func updateRespondedAds() {
        if let user = activeUser {
            Task {
                let respondedAds = try await networkService?.fetchRespondedAdsByUserId(id: user.id)

                if let ads = respondedAds {
                    await withTaskGroup(of: (Ad, User?).self) { group in

                        for ad in ads {
                            group.addTask {
                                let user = await self.fetchAuthorForAdFromServer(id: user.id)
                                return (ad, user)
                            }
                        }

                        for await (ad, user) in group {
                            if let user = user {
                                respondedAdsWithUsers.updateValue(user, forKey: ad)
                            }
                        }
                        view?.updateDataSource(with: respondedAds ?? [])
                    }
                } else {
                    respondedAdsWithUsers = [:]
                }
            }
        }
    }

    func subscribeOnActiveUser() {
        AuthManager.shared.$activeUser
            .sink { [weak self] user in
                if let user = user {
                    self?.activeUser = user
                    self?.view?.updateView(isActiveUserExist: true)
                } else {
                    self?.view?.updateView(isActiveUserExist: false)
                }
            }.store(in: &subscripitions)
    }

    func fetchAuthorForAdFromServer(id: String) async -> User? {
        do {
            let user = try await networkService?.fetchUserById(id: id)
            return user
        } catch {
            return nil
        }
    }

    func fetchAuthorForAd(ad: Ad) -> User? {
        if let user = respondedAdsWithUsers[ad] {
            return user
        } else {
            return publishedAdsWithUsers[ad]
        }
    }
}
