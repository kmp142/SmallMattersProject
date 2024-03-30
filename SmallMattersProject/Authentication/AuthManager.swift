//
//  AuthManager.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.03.2024.
//

import Foundation
import FirebaseAuth

class AuthManager {

    static let shared = AuthManager()

    private let auth = Auth.auth()

    private var verificationId: String?

    private init(verificationId: String? = nil) {
        self.verificationId = verificationId
    }

    private var currentUser: FirebaseAuth.User? {
        return auth.currentUser
    }

    func signIn(email: String, 
                password: String,
                completion: @escaping (Result<FirebaseAuth.User, Error>) -> Void) {
        print("email: \(email); password \(password)")
        auth.signIn(withEmail: email, password: password) { result, error in
            print(result as Any)
            print("email: \(email); password \(password)")
            if let result = result {
                completion(.success(result.user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

 }
