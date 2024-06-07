//
//  NetworkService.swift
//  SmallMattersProject
//
//  Created by Dmitry on 05.05.2024.
//

import Foundation
import Alamofire
import CoreData

protocol NetworkServiceInterface {
    func fetchUserById(id: String) async throws -> User?
    func fetchActiveAdsFromServer() async throws -> [Ad]
    func fetchReviewsByUserId(id: String) async throws -> [Review]
    func fetchRespondedAdsByUserId(id: String) async throws -> [Ad]
    func fetchPublishedAdsByUserId(id: String) async throws -> [Ad]
    func updateAd(ad: Ad) async throws
    func publicAd(_ ad: Ad) async throws
}

class NetworkService: NetworkServiceInterface {

    func fetchUserById(id: String) async throws -> User? {
        let decoder = createJSONDecoder(with: PersistentContainer.shared.viewContext)
        let urlString = "https://663525fa9bb0df2359a3f327.mockapi.io/api/users?id=\(id)"
        let users = try await AF.request(urlString)
            .serializingDecodable([User].self, decoder: decoder)
            .value
        return users.first
    }

    func fetchActiveAdsFromServer() async throws -> [Ad] {
        let decoder = createJSONDecoder(with: PersistentContainer.shared.viewContext)
        let params = "state=active"
        return try await AF.request("https://663525fa9bb0df2359a3f327.mockapi.io/api/ad?" + params).serializingDecodable([Ad].self, decoder: decoder)
            .value
    }

    func fetchReviewsByUserId(id: String) async throws -> [Review] {
        let decoder = createJSONDecoder(with: PersistentContainer.shared.viewContext)
        let params = "receiverId=\(id)"
        let url = "https://66487b0b2bb946cf2fa0b630.mockapi.io/Review?" + params

        return try await AF.request(url)
            .serializingDecodable([Review].self, decoder: decoder)
            .value
    }

    func updateAd(ad: Ad) async throws {
        let encoder = createJSONEncoder(with: PersistentContainer.shared.viewContext)

        let parameterEncoder = JSONParameterEncoder(encoder: encoder)
        let url = "https://663525fa9bb0df2359a3f327.mockapi.io/api/ad/\(ad.id)"
        let contentTypeHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        let headers = HTTPHeaders([contentTypeHeader])

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .put, parameters: ad, encoder: parameterEncoder, headers: headers).response { response in
                switch response.result {
                case .success:
                    if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                        continuation.resume()
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected status code: \(response.response?.statusCode ?? -1)"])
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func publicAd(_ ad: Ad) async throws {
        let encoder = createJSONEncoder(with: PersistentContainer.shared.viewContext)
        let parameterEncoder = JSONParameterEncoder(encoder: encoder)
        
        let url = "https://663525fa9bb0df2359a3f327.mockapi.io/api/ad"
        let contentTypeHeader = HTTPHeader(name: "Content-Type", value: "application/json")
        let headers = HTTPHeaders([contentTypeHeader])
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .post, parameters: ad, encoder: parameterEncoder, headers: headers).response { response in
                switch response.result {
                case .success:
                    print(ad)
                    if let statusCode = response.response?.statusCode, (200...299).contains(statusCode) {
                        continuation.resume()
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected status code: \(response.response?.statusCode ?? -1)"])
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func fetchRespondedAdsByUserId(id: String) async throws -> [Ad] {
        let decoder = createJSONDecoder(with: PersistentContainer.shared.viewContext)
        let params = "executorId=\(id)"
        return try await AF.request("https://663525fa9bb0df2359a3f327.mockapi.io/api/ad?" + params).serializingDecodable([Ad].self, decoder: decoder)
            .value
    }

    func fetchPublishedAdsByUserId(id: String) async throws -> [Ad] {
        let decoder = createJSONDecoder(with: PersistentContainer.shared.viewContext)
        let params = "authorId=\(id)"
        return try await AF.request("https://663525fa9bb0df2359a3f327.mockapi.io/api/ad?" + params).serializingDecodable([Ad].self, decoder: decoder)
            .value
    }

    private func createJSONDecoder(with context: NSManagedObjectContext) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        return decoder
    }

    private func createJSONEncoder(with context: NSManagedObjectContext) -> JSONEncoder {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Формат даты, который вы хотите использовать
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
        return encoder
    }
}
