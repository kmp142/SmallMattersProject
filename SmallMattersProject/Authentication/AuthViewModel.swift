//
//  AuthenticationViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.03.2024.
//

import Foundation
import Combine
import UIKit

enum UserAuthenticationError: Error {
    case incorrectPassword
    case incorrectLogin
}

protocol AuthViewModelInterface {
    func login(login: String, password: String)
}

class AuthViewModel: AuthViewModelInterface {

    weak var view: AuthVCInterface?

    func login(login: String, password: String) {
        AuthManager.shared.signIn(email: login, password: password) { result in
            switch result {
            case .success(_):
                self.view?.crossToMainTabBar()
            case .failure(_):
                self.view?.showLoginFailure()
            }
        }
    }
}
