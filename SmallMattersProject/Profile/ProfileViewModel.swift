//
//  ProfileViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 21.04.2024.
//

import Foundation
import Combine

// TODO: - Make viewModel logic

protocol ProfileViewModelInterface {
    func saveNewAvatarImage(imagePath: String)
}

class ProfileViewModel: ProfileViewModelInterface {

    @Published var user: User?
    @Published var reviews: [Review] = []
    private let networkService: NetworkServiceInterface
    @Published var isEditingEnable: Bool
    weak var view: ProfileViewControllerInterface?

    private var subscriptions = Set<AnyCancellable>()

    init(user: User?, networkService: NetworkServiceInterface) {
        self.networkService = networkService
        if let receivedUser = user {
            self.user = receivedUser
            isEditingEnable = false
            Task {
                self.reviews = try await networkService.fetchReviewsByUserId(id: receivedUser.id)
            }
        } else {
            isEditingEnable = true
            subscribeOnActiveUser()
        }
    }

    func saveNewAvatarImage(imagePath: String) {
        user?.imageLink = imagePath
        view?.updateCollectionView()
        PersistentContainer.shared.saveContext()
    }

    private func subscribeOnActiveUser() {
        AuthManager.shared.$activeUser
            .sink(receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.user = user
                if let user = user {
                    Task {
                        self.reviews = try await self.networkService.fetchReviewsByUserId(id: user.id)
                    }
                }
            }).store(in: &subscriptions)
    }

    private func updateUserReviews() {

    }
}
