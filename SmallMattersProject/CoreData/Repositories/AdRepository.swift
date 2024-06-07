//
//  AdRepository.swift
//  SmallMattersProject
//
//  Created by Dmitry on 31.05.2024.
//

import Foundation
import CoreData

class AdRepository<User: NSManagedObject>: EntityRepositoryInterface {
    
    var context: NSManagedObjectContext

    typealias EntityType = Ad

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAllFromCoreData() -> [Ad] {
        do {
            let fetchRequest = Ad.fetchRequest()
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("Error fetching users: \(error)")
        }
    }

    func saveContext() {

    }

    func deleteFromCoreData(_ entity: Ad) {

    }
}
