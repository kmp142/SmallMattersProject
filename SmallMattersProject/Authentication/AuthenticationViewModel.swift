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

class AuthViewModel {

//    private var authenticationResult: Result<User, UserAuthenticationError>? {
//        willSet {
//            guard let newValue = newValue else { return }
//
//            switch newValue {
//            case .success(let User):
//                print("success authentication")
//                break
//            case .failure(let error):
//                print("failure authentication")
//                break
//            }
//        }
//    }

    init() {
    
    }

    func login(login: String, password: String) {
        print("login: \(login); password \(password)")
        AuthManager.shared.signIn(email: login, password: password) { result in
            switch result {
            case .success(let user):
                print("пользователь \(user.uid)успешно вошел")
            case .failure(let error):
                print("данные введеные неверно \(error.localizedDescription)")
            }
        }
    }
}
