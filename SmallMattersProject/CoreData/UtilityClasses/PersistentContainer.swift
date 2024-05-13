//
//  CoreDataManager.swift
//  SmallMattersProject
//
//  Created by Dmitry on 04.05.2024.
//

import Foundation
import CoreData

class PersistentContainer {

    static let shared = PersistentContainer()

    private init(){}

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SmallMattersProject")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error {
                fatalError("\(error.localizedDescription)")
            }
        })
        return container
    }()

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("\(error.localizedDescription)")
            }
        }
    }

    func getLoginedUser() -> User? {
        let userFetchRequest = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "isLoggedIn == true")

        do {
            let users = try viewContext.fetch(userFetchRequest)
            return users.first
        } catch {
            fatalError()
        }
    }
}
