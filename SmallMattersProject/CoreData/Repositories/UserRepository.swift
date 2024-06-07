//
//  UserRepository.swift
//  SmallMattersProject
//
//  Created by Dmitry on 05.05.2024.
//

import Foundation
import CoreData

class UserRepository: EntityRepositoryInterface {

    var context: NSManagedObjectContext
    
    typealias EntityType = User

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAllFromCoreData() -> [User] {
        do {
            let fetchRequest = User.fetchRequest()
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("Error fetching users: \(error)")
        }
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError("Error saving context: \(error)")
        }
    }

    func fetchLoggedInUser() -> User? {
        let fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == true")
        do {
            let fetchedArray = try context.fetch(fetchRequest)
            if fetchedArray.count > 1 {
                fatalError("LoggedIn users count more than 1")
            }
            return fetchedArray.first 
        } catch {
            fatalError("Error fetching loggedIn user: \(error)")
        }
    }

    func deleteFromCoreData(_ entity: User) {
        context.delete(entity)
    }
}
