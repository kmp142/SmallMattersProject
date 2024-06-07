//
//  User+CoreDataClass.swift
//  SmallMattersProject
//
//  Created by Dmitry on 18.05.2024.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable {

    enum CodingKeys: CodingKey {
        case id, isLoggedIn, imageLink, name, rating, registrationDate, locationLatitude, locationLongitude, addressName, telegramNameId, phoneNumber
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
              throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.isLoggedIn = try container.decode(Bool.self, forKey: .isLoggedIn)
        self.imageLink = try container.decode(String.self, forKey: .imageLink)
        self.name = try container.decode(String.self, forKey: .name)
        self.rating = try container.decode(Double.self, forKey: .rating)
        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.registrationDate = try dateFormatter.date(from: container.decode(String.self, forKey: .registrationDate)) ?? Date()
        } catch {
            throw DecodingError.dataCorruptedError(forKey: .registrationDate, in: container, debugDescription: "error")
        }
        self.locationLatitude = try container.decode(Double.self, forKey: .locationLatitude)
        self.locationLongitude = try container.decode(Double.self, forKey: .locationLongitude)
        do {
            self.addressName = try container.decode(String.self, forKey: .addressName)
        } catch {
            self.addressName = nil
        }
        self.telegramNameId = try container.decode(String.self, forKey: .telegramNameId)
        self.phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(isLoggedIn, forKey: .isLoggedIn)
        try container.encode(imageLink, forKey: .imageLink)
        try container.encode(name, forKey: .name)
        try container.encode(rating, forKey: .rating)
        try container.encode(registrationDate, forKey: .registrationDate)
      }
}
