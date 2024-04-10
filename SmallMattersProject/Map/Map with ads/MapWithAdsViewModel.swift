//
//  ClusterizedMapViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 27.03.2024.
//

import Foundation

protocol MapWithAdsViewModelInterface {
    func updateAds()
}

class MapWithAdsViewModel: MapWithAdsViewModelInterface {

    @Published var ads: [Ad] = []

    init() {
        updateAds()
    }

    func updateAds() {
        ads += AdsService.shared.getAdsFromServer()
    }
}
