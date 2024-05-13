//
//  NetworkService.swift
//  SmallMattersProject
//
//  Created by Dmitry on 05.05.2024.
//

import Foundation
import Alamofire

class NetworkService {

    func fetchAdsFromServer() async -> String {
        let request = AF.request("https://663525fa9bb0df2359a3f327.mockapi.io/api/users")
        return await request.serializingString().response.description
    }

}
