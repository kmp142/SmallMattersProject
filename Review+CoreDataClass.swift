//
//  Review+CoreDataClass.swift
//  SmallMattersProject
//
//  Created by Dmitry on 17.05.2024.
//
//

import Foundation
import CoreData

@objc(Review)
public class Review: NSManagedObject, Codable {

    enum CodingKeys: CodingKey {
        case id, publicationDate, text, value, adId, authorId, receiverId, adTitleAndBounty
    }

    public required convenience init(from decoder: Decoder) throws {

        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
              throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.publicationDate = try dateFormatter.date(from: container.decode(String.self, forKey: .publicationDate)) ?? Date()
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .publicationDate, in: container, debugDescription: "error")
        }
        self.text = try container.decode(String.self, forKey: .text)
        self.value = try container.decode(Int16.self, forKey: .value)
        self.adId = try container.decode(String.self, forKey: .adId)
        self.authorId = try container.decode(String.self, forKey: .authorId)
        self.receiverId = try container.decode(String.self, forKey: .receiverId)
        self.adTitleAndBounty = try container.decode(String.self, forKey: .adTitleAndBounty)
    }

    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
      }

}
