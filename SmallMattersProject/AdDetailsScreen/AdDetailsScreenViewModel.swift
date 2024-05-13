//
//  AdDetailsScreenViewModel.swift
//  SmallMattersProject
//
//  Created by Dmitry on 30.04.2024.
//

import Foundation

protocol AdDetailsScreenViewModelInterface {

}

class AdDetailsScreenViewModel: AdDetailsScreenViewModelInterface {

    @Published var ad: Ad

    init(ad: Ad) {
        self.ad = ad
    }
}
