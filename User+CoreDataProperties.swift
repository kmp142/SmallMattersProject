//
//  User+CoreDataProperties.swift
//  SmallMattersProject
//
//  Created by Dmitry on 25.05.2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var addressName: String?
    @NSManaged public var id: String
    @NSManaged public var imageLink: String
    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double
    @NSManaged public var name: String
    @NSManaged public var rating: Double
    @NSManaged public var registrationDate: Date
    @NSManaged public var telegramNameId: String
    @NSManaged public var phoneNumber: String

}

extension User : Identifiable {

}
