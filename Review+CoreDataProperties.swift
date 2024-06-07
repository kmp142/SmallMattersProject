//
//  Review+CoreDataProperties.swift
//  SmallMattersProject
//
//  Created by Dmitry on 20.05.2024.
//
//

import Foundation
import CoreData


extension Review {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }

    @NSManaged public var adId: String
    @NSManaged public var authorId: String
    @NSManaged public var id: String
    @NSManaged public var publicationDate: Date
    @NSManaged public var receiverId: String
    @NSManaged public var text: String
    @NSManaged public var value: Int16
    @NSManaged public var adTitleAndBounty: String

}

extension Review : Identifiable {

}
