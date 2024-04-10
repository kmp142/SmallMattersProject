//
//  MainTapeViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 01.04.2024.
//

import Foundation

protocol MainTapeViewModelInterface {}

class MainTapeViewModel: MainTapeViewModelInterface {

    @Published var ads: [Ad] = []

    init() {
        self.ads = AdsService.shared.getAdsFromServer()
    }
}
