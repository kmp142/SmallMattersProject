//
//  Classfield.swift
//  SmallMattersProject
//
//  Created by Dmitry on 20.03.2024.
//

import Foundation

struct Ad: Hashable {
    let id = UUID()
    let author: User
    var executor: User?
    var cost: Double
    var name: String
    var description: String
    var location: Coordinates
    var deadline: Date
    var minimalUserRating: Int
}

extension Ad {
    init() {
        author = User()
        executor = User(name: "someName \(Int.random(in: 0...190))", registrationDate: Date.now - 10)
        cost = 100
        name = "Название объявления"
        description = "Нужно почистить снег"
        location = Coordinates(latitude: Double.random(in: 50.0 ... 55.0),
                               longitude: Double.random(in: 40.0 ... 50.0))
        deadline = Date.now + Double.random(in: 1...172800)
        minimalUserRating = 5
    }
}
