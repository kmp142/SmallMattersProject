//
//  Classfield.swift
//  SmallMattersProject
//
//  Created by Dmitry on 20.03.2024.
//

import Foundation
import UIKit

struct Ad: Hashable {
    let id: UUID
    let author: User
    var executor: User?
    var distanceToUser: Double?
    var bounty: Double
    var name: String
    var description: String
    var location: Location
    var deadline: Date
    var minimalUserRating: Int
}

extension Ad {
    init() {
        id = UUID()
        author = User()
        executor = User(id: UUID(), image: UIImage(named: "bluePin")!, name: "someName \(Int.random(in: 0...190))", registrationDate: Date.now - 10, rating: Double.random(in: 1...5))
        bounty = Double.random(in: 100...999)
        name = "Чистка парковки от снега"
        description = "Нужно почистить снег"
        location = Location(latitude: Double.random(in: 55.7640...55.8199),
                               longitude: Double.random(in: 49.1023...49.1502))
        deadline = Date.now + Double.random(in: 1...172800)
        minimalUserRating = 5
    }
}
