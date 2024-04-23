//
//  MainTapeViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 01.04.2024.
//

import Foundation
import YandexMapsMobile

protocol MainTapeViewModelInterface {
    func updateAllAds()
}

class MainTapeViewModel: MainTapeViewModelInterface {

    @Published var ads: [Ad] = []
    private let routeBuilder = YRouteBuilder()
    private var userLocation: Location = Location(latitude: 55.791941, longitude: 49.126231)

    init() {
        updateAllAds()
    }

    func updateAllAds() {
        ads = AdsService.shared.getAdsFromServer()
    }
}
