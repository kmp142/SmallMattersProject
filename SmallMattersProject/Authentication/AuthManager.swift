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

    static let shared = AuthManager(networkService: NetworkService())

    private init(networkService: NetworkServiceInterface) {
        self.networkService = networkService
        let userRepository = UserRepository(context: PersistentContainer.shared.viewContext)
        let user = userRepository.fetchLoggedInUser()
        activeUser = user
    }

    private let auth = Auth.auth()
    private let networkService: NetworkServiceInterface?
    @Published var activeUser: User?

    func signIn(email: String,
                password: String,
                completion: @escaping (Result<Any, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                completion(.success(result))
                let loggedInUserId = self.auth.currentUser?.uid
                Task {
                    let user = try await self.networkService?.fetchUserById(id: loggedInUserId ?? "")
                    if let user = user {
                        user.isLoggedIn = true
                        self.activeUser = user
                        PersistentContainer.shared.saveContext()
                    }
                }
            }   else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func logOut() {
        if let user = activeUser {
            PersistentContainer.shared.deleteObject(user)
            PersistentContainer.shared.saveContext()
            activeUser = nil
        }
    }
}

