//
//  User.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.03.2024.
//

import Foundation


struct User: Hashable {
    var name: String
    let registrationDate: Date
}

extension User {
    init(){
        name = "Oleg \(Int.random(in: 0...250))"
        registrationDate = Date.now
    }
}
