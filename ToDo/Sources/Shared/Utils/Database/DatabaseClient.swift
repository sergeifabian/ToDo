//
//  DatabaseClient.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation
import CoreData

protocol DatabaseClient {
    var viewContext: NSManagedObjectContext { get }
    func performBackgroundTask(completion: @escaping TypeClosure<NSManagedObjectContext>)
}

final class DatabaseClientImpl: DatabaseClient {

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Database")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { _, error in
            if let error {
                // FIXME: Additional requirements required
                fatalError(error.localizedDescription)
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    func performBackgroundTask(completion: @escaping TypeClosure<NSManagedObjectContext>) {
        container.performBackgroundTask { context in
            context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            completion(context)
        }
    }
}
