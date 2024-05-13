//
//  UserRepository.swift
//  SmallMattersProject
//
//  Created by Dmitry on 05.05.2024.
//

import Foundation
import CoreData

class UserRepository<User: NSManagedObject>: EntityRepositoryInterface {

    var context: NSManagedObjectContext
    
    typealias EntityType = User

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAllFromCoreData() -> [User] {
        do {
            let fetchRequest = User.fetchRequest()
            return try context.fetch(fetchRequest) as? [User] ?? []
        } catch {
            fatalError("Error fetching entities: \(error)")
        }
    }

    func saveToCoreData(_ entity: User) {
        do {
            try entity.managedObjectContext?.save()
        } catch {
            fatalError("Error saving entity: \(error)")
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
            return fetchedArray.first as? User
        } catch {
            fatalError("Error fetching loggedIn user: \(error)")
        }
    }

    func deleteFromCoreData(_ entity: User) {
        context.delete(entity)
    }
}
