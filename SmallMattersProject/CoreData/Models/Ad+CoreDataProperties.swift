//
//  Ad+CoreDataProperties.swift
//  SmallMattersProject
//
//  Created by Dmitry on 04.05.2024.
//
//

import Foundation
import CoreData


extension Ad {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ad> {
        return NSFetchRequest<Ad>(entityName: "Ad")
    }

    @NSManaged public var adDescription: String?
    @NSManaged public var bounty: Double
    @NSManaged public var deadline: Date
    @NSManaged public var distanceToUser: Double
    @NSManaged public var id: UUID?
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double
    @NSManaged public var minimalExecutorRating: Int
    @NSManaged public var name: String
    @NSManaged public var state: String?
    @NSManaged public var author: User
    @NSManaged public var executor: User?
    @NSManaged public var review: Review?

}

extension Ad : Identifiable {

}
