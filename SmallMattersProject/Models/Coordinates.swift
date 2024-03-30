//
//  Address.swift
//  SmallMattersProject
//
//  Created by Dmitry on 20.03.2024.
//

import Foundation

struct Coordinates: Hashable {
    let latitude: Double
    let longitude: Double
}

extension Coordinates {
    init(){
        latitude = 55.791941
        longitude = 49.126231
    }
}
