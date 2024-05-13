//
//  AuthManager.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.03.2024.
//

import Foundation
import FirebaseAuth

protocol AuthManagerInterface: AnyObject {
    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<Any, Error>) -> Void
    )
}

class AuthManager: AuthManagerInterface {

    private let auth = Auth.auth()

    var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }

    func signIn(email: String, 
                password: String,
                completion: @escaping (Result<Any, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

 }
