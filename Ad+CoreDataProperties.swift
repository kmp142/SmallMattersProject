//
//  Ad+CoreDataProperties.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.05.2024.
//
//

import Foundation
import CoreData

extension Ad {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ad> {
        return NSFetchRequest<Ad>(entityName: "Ad")
    }

    @NSManaged public var adDescription: String
    @NSManaged public var authorId: String
    @NSManaged public var bounty: Double
    @NSManaged public var deadline: Date
    @NSManaged public var distanceToUser: Double
    @NSManaged public var executorId: String?
    @NSManaged public var id: String
    @NSManaged public var locationLatitude: Double
    @NSManaged public var locationLongitude: Double
    @NSManaged public var minimalExecutorRating: Int16
    @NSManaged public var state: String
    @NSManaged public var title: String

}

extension Ad : Identifiable {

}
