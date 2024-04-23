//
//  AdsService.swift
//  SmallMattersProject
//
//  Created by Dmitry on 29.03.2024.
//

import Foundation
import YandexMapsMobile

class AdsService {

    static let shared = AdsService()
    let routeBuilder = YRouteBuilder()
    let userLocation = Location(latitude: 55.791941, longitude: 49.126231)

    private(set) var ads: [Ad] = []

    func getAdsFromServer() -> [Ad] {
        return [Ad() ,Ad(), Ad(), Ad(), Ad(), Ad(),
                   Ad() ,Ad(), Ad(), Ad(), Ad(), Ad()]
    }

    func getAdsWithDistanceFromUserDefaults() {
        
    }
}
