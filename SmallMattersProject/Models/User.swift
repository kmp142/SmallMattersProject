//
//  User.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.03.2024.
//

import Foundation
import UIKit

struct User: Hashable {
    let id: UUID
    var image: UIImage
    var name: String
    let registrationDate: Date
    let rating: Double
}

extension User {
    init(){
        id = UUID()
        name = "Oleg \(Int.random(in: 0...250))"
        registrationDate = Date.now
        rating = Double.random(in: 1...5)
        image = UIImage(named: "bluePin")!
    }
}
