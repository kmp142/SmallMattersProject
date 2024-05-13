//
//  Review+CoreDataProperties.swift
//  SmallMattersProject
//
//  Created by Dmitry on 04.05.2024.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var id: UUID
    @NSManaged public var publicationDate: Date
    @NSManaged public var text: String
    @NSManaged public var value: Int
    @NSManaged public var ad: Ad
    @NSManaged public var author: User
}

extension Review : Identifiable {

}
