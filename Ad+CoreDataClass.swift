//
//  Ad+CoreDataClass.swift
//  SmallMattersProject
//
//  Created by Dmitry on 17.05.2024.
//
//

import Foundation
import CoreData


@objc(Ad)
public class Ad: NSManagedObject, Codable {
    
    enum CodingKeys: CodingKey {
        case adDescription, bounty, deadline, distanceToUser, id, locationLatitude, locationLongitude, minimalExecutorRating, title, state, authorId, executorId, review
    }

    public required convenience init(from decoder: Decoder) throws {

        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
              throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.adDescription = try container.decode(String.self, forKey: .adDescription)
        self.bounty = try container.decode(Double.self, forKey: .bounty)
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "ru_RU")
            let string = try container.decode(String.self, forKey: .deadline)
            print(string)
            self.deadline = dateFormatter.date(from: string) ?? Date.now
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .deadline, in: container, debugDescription: "error")
        }
        self.distanceToUser = try container.decode(Double.self, forKey: .distanceToUser)
        self.id = try container.decode(String.self, forKey: .id)
        self.locationLatitude = try container.decode(Double.self, forKey: .locationLatitude)
        self.locationLongitude = try container.decode(Double.self, forKey: .locationLongitude)
        self.title = try container.decode(String.self, forKey: .title)
        self.state = try container.decode(String.self, forKey: .state)
        self.authorId = try container.decode(String.self, forKey: .authorId)
        self.minimalExecutorRating = try container.decode(Int16.self, forKey: .minimalExecutorRating)
        self.executorId = try container.decodeIfPresent(String.self, forKey: .executorId) ?? nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(adDescription, forKey: .adDescription)
        try container.encode(id, forKey: .id)
        try container.encode(bounty, forKey: .bounty)
        try container.encode(distanceToUser, forKey: .distanceToUser)
        try container.encode(locationLatitude, forKey: .locationLatitude)
        try container.encode(locationLongitude, forKey: .locationLongitude)
        try container.encode(title, forKey: .title)
        try container.encode(state, forKey: .state)
        try container.encode(authorId, forKey: .authorId)
        try container.encode(minimalExecutorRating, forKey: .minimalExecutorRating)
        try container.encode(executorId, forKey: .executorId)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        try container.encode(dateFormatter.string(from: deadline), forKey: .deadline)
      }
}
