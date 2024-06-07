//
//  AdDetailsScreenViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 30.04.2024.
//

import Foundation

protocol AdDetailsScreenViewModelInterface {
    func getUserPhoneNumber() -> String
    func getUserTelegramNameId() -> String
    func respondeOnAdTapped()
}

class AdDetailsScreenViewModel: AdDetailsScreenViewModelInterface {

    let ad: Ad
    let adAuthor: User
    weak var view: AdDetailsVCInterface?
    var networkService: NetworkServiceInterface?

    init(ad: Ad, author: User, networkService: NetworkServiceInterface) {
        self.ad = ad
        self.adAuthor = author
        self.networkService = networkService
    }

    func getUserPhoneNumber() -> String {
        adAuthor.phoneNumber
    }

    func getUserTelegramNameId() -> String {
        adAuthor.telegramNameId
    }

    func respondeOnAdTapped() {
        if let user = AuthManager.shared.activeUser, adAuthor.id != user.id {
            switch ad.state {
            case "active":
                ad.state = "executing"
                ad.executorId = user.id
            case "executing":
                ad.state = "executed"
            default:
                view?.showFailureAlert()
                return
            }

            Task {
                try await networkService?.updateAd(ad: ad)
            }

            view?.adSuccessfulResponded()
        } else if let user = AuthManager.shared.activeUser, ad.executorId == user.id {
            if ad.state == "executing" {
                ad.state = "executed"
                Task {
                    try await networkService?.updateAd(ad: ad)
                }
                view?.adSuccessfulResponded()
            }
        }
        else {
            view?.showFailureAlert()
        }
    }
}
