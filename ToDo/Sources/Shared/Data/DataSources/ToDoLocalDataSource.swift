//
//  ToDoLocalDataSource.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation
import CoreData

protocol HasToDoLocalDataSource {
    var toDoLocalDataSource: ToDoLocalDataSource { get }
}

protocol ToDoLocalDataSource {
    func upsert(_ items: [ToDoPersistenceDTO], completion: @escaping ResultClosure<Void>)
    func toggle(id: String, completion: @escaping ResultClosure<Void>)
    func fetch(id: String, completion: @escaping ResultClosure<ToDoEntity?>)
    func delete(id: String, completion: @escaping ResultClosure<Void>)
    func createFetchedResultsController(query: String?) -> NSFetchedResultsController<ToDoEntity>
}

final class ToDoLocalDataSourceImpl: ToDoLocalDataSource {
    private let databaseClient: DatabaseClient

    init(databaseClient: DatabaseClient) {
        self.databaseClient = databaseClient
    }

    func upsert(_ items: [ToDoPersistenceDTO], completion: @escaping ResultClosure<Void>) {
        guard items.isNotEmpty else { return completion(.success(())) }

        databaseClient.performBackgroundTask { [weak self] context in
            guard let self else { return }

            do {
                try self.upsert(items, in: context)

                if context.hasChanges {
                    try context.save()
                }

                completion(.success(()))
            } catch {
                context.rollback()

                completion(.failure(error))
            }
        }
    }

    func toggle(id: String, completion: @escaping ResultClosure<Void>) {
        databaseClient.performBackgroundTask { [weak self] context in
            guard let self else { return }

            do {
                let entities = try self.fetchByIds([id], in: context)

                for entity in entities.values {
                    entity.completed.toggle()
                }

                if context.hasChanges {
                    try context.save()
                }

                completion(.success(()))
            } catch {
                context.rollback()

                completion(.failure(error))
            }
        }
    }

    func fetch(id: String, completion: @escaping ResultClosure<ToDoEntity?>) {
        let context = databaseClient.viewContext

        do {
            let entities = try fetchByIds([id], in: context)

            completion(.success(entities.values.first))
        } catch {
            completion(.failure(error))
        }
    }

    func delete(id: String, completion: @escaping ResultClosure<Void>) {
        databaseClient.performBackgroundTask { [weak self] context in
            guard let self else { return }

            do {
                let entities = try self.fetchByIds([id], in: context)

                for entity in entities.values {
                    context.delete(entity)
                }

                if context.hasChanges {
                    try context.save()
                }

                completion(.success(()))
            } catch {
                context.rollback()

                completion(.failure(error))
            }
        }
    }

    func createFetchedResultsController(query: String?) -> NSFetchedResultsController<ToDoEntity> {
        let request = ToDoEntity.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(keyPath: \ToDoEntity.date, ascending: false)]

        if let query {
            request.predicate = NSPredicate(format: "(title CONTAINS[c] %@) OR (details CONTAINS[c] %@)", query, query)
        }

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: databaseClient.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        return fetchedResultsController
    }
}

private extension ToDoLocalDataSourceImpl {
    func upsert(_ items: [ToDoPersistenceDTO], in context: NSManagedObjectContext) throws {
        let ids = items.map(\.id)
        let entities = try fetchByIds(ids, in: context)

        for item in items {
            let entity = entities[item.id] ?? ToDoEntity(context: context)

            if entity.identifier == nil {
                entity.identifier = item.id
            }

            entity.title = item.title
            entity.details = item.details
            entity.completed = item.completed

            if entity.date == nil {
                if let date = item.date {
                    entity.date = date
                } else {
                    entity.date = Date.now
                }
            }
        }
    }

    func fetchByIds(_ ids: [String], in context: NSManagedObjectContext) throws -> [String: ToDoEntity] {
        if ids.isEmpty { return [:] }

        let request = ToDoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "identifier IN %@", ids)

        let items = try context.fetch(request)

        return items.reduce(into: [String: ToDoEntity]()) { partialResult, entity in
            if let id = entity.identifier {
                partialResult.updateValue(entity, forKey: id)
            }
        }
    }
}
