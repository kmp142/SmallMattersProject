//
//  ProfileViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 21.04.2024.
//

import Foundation

// TODO: - Make viewModel logic

protocol ProfileViewModelInterface {
    func saveNewAvatarImage()
}

class ProfileViewModel: ProfileViewModelInterface {

    let user: User?

    init(user: User?) {
        self.user = user
    }

    func saveNewAvatarImage() {
        
    }
}
