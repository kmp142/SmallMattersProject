//
//  EntityRepositoryInterface.swift
//  SmallMattersProject
//
//  Created by Dmitry on 05.05.2024.
//

import Foundation
import CoreData

protocol EntityRepositoryInterface {

    associatedtype EntityType: NSManagedObject

    var context: NSManagedObjectContext {get}

    //MARK: - Core data

    func fetchAllFromCoreData() -> [EntityType]
    func saveContext()
    func deleteFromCoreData(_ entity: EntityType)
}
