//
//  User+CoreDataProperties.swift
//  SmallMattersProject
//
//  Created by Dmitry on 04.05.2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var imageLink: String?
    @NSManaged public var name: String
    @NSManaged public var rating: Double
    @NSManaged public var registrationDate: Date
    @NSManaged public var executedAds: Set<Ad>
    @NSManaged public var publishedAds: Set<Ad>
    @NSManaged public var reviews: Set<Review>
}

// MARK: Generated accessors for executedAds
extension User {

    @objc(addExecutedAdsObject:)
    @NSManaged public func addToExecutedAds(_ value: Ad)

    @objc(removeExecutedAdsObject:)
    @NSManaged public func removeFromExecutedAds(_ value: Ad)

    @objc(addExecutedAds:)
    @NSManaged public func addToExecutedAds(_ values: NSSet)

    @objc(removeExecutedAds:)
    @NSManaged public func removeFromExecutedAds(_ values: NSSet)

}

// MARK: Generated accessors for publishedAds
extension User {

    @objc(addPublishedAdsObject:)
    @NSManaged public func addToPublishedAds(_ value: Ad)

    @objc(removePublishedAdsObject:)
    @NSManaged public func removeFromPublishedAds(_ value: Ad)

    @objc(addPublishedAds:)
    @NSManaged public func addToPublishedAds(_ values: NSSet)

    @objc(removePublishedAds:)
    @NSManaged public func removeFromPublishedAds(_ values: NSSet)

}

// MARK: Generated accessors for reviews
extension User {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}

extension User : Identifiable {

}
