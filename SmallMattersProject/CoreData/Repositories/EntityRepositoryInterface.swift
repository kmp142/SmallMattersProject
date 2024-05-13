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
    func saveToCoreData(_ entity: EntityType)
    func deleteFromCoreData(_ entity: EntityType)
//    func deleteAllEntitiesOfType(_: EntityType)

    //MARK: - Network

//    func fetchAllFromNetwork() async throws -> [EntityType]
//    func saveOnServer(_ entity: EntityType) async throws
//    func fetchById(id: String) async throws -> EntityType
}
