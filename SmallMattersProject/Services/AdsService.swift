//
//  AdsService.swift
//  SmallMattersProject
//
//  Created by Dmitry on 29.03.2024.
//

import Foundation

class AdsService {

    static let shared = AdsService()

    func getAdsFromServer() -> [Ad] {
        return [Ad() ,Ad(), Ad(), Ad(), Ad()]
    }
}
