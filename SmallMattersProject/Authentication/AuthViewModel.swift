//
//  AuthenticationViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.03.2024.
//

import Foundation
import Combine
import UIKit
import Firebase

enum UserAuthenticationError: Error {
    case incorrectPassword
    case incorrectLogin
}

protocol AuthViewModelInterface {
    func login(login: String, password: String)
}

class AuthViewModel: AuthViewModelInterface {

    weak var view: AuthVCInterface?

    private var authManager: AuthManagerInterface?

    init(authManager: AuthManagerInterface) {
        self.authManager = authManager
    }

    func login(login: String, password: String) {
        authManager?.signIn(email: login, password: password) { result in
            switch result {
            case .success(let user):
                if let user = user as? FirebaseAuth.User {
                    self.view?.crossToMainTabBar(withUserId: user.uid)
                } else {
                    self.view?.crossToMainTabBar(withUserId: nil)
                }
            case .failure(_):
                self.view?.showLoginFailure()
            }
        }
    }
}
