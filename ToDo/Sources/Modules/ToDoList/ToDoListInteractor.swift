//
//  ToDoListInteractor.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation
import CoreData

protocol ToDoListInteractor: AnyObject {
    func fetchInitialData()
    func search(query: String?)
    func toggle(id: String)
    func delete(id: String)
}

protocol ToDoListInteractorOutput: AnyObject {
    func didUpdateItems(_ items: [ToDo])
    func didFailToSyncItems(_ error: Error)
    func didFailToObserveItems(_ error: Error)
    func didFailToToggleItem(_ error: Error)
    func didFailToDeleteItem(_ error: Error)
}

final class ToDoListInteractorImpl: NSObject {

    weak var output: ToDoListInteractorOutput?

    // MARK: - Data

    private var fetchedResultsController: NSFetchedResultsController<ToDoEntity>?

    // MARK: - Dependencies

    private let toDoRepository: ToDoRepository
    private let firstLaunchService: FirstLaunchService
    private let toDoObservationService: ToDoObservationService

    // MARK: - Lifecycle

    init(
        toDoRepository: ToDoRepository,
        firstLaunchService: FirstLaunchService,
        toDoObservationService: ToDoObservationService
    ) {
        self.toDoRepository = toDoRepository
        self.firstLaunchService = firstLaunchService
        self.toDoObservationService = toDoObservationService
    }
}

// MARK: - ToDoListInteractor

extension ToDoListInteractorImpl: ToDoListInteractor {
    func fetchInitialData() {
        setupObservation(query: nil)
        syncRemoteDataIfNeeded()
    }

    func search(query: String?) {
        setupObservation(query: query)
    }

    func toggle(id: String) {
        toDoRepository.toggle(id: id) { [weak self] result in
            if case let Result.failure(error) = result {
                self?.output?.didFailToToggleItem(error)
            }
        }
    }

    func delete(id: String) {
        toDoRepository.delete(id: id) { [weak self] result in
            if case let Result.failure(error) = result {
                self?.output?.didFailToDeleteItem(error)
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ToDoListInteractorImpl: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        if let fetchedObjects = controller.fetchedObjects as? [ToDoEntity] {
            sendObjects(fetchedObjects: fetchedObjects)
        }
    }
}

// MARK: - Utils

private extension ToDoListInteractorImpl {
    func setupObservation(query: String?) {
        do {
            fetchedResultsController = toDoObservationService.createFetchedResultsController(query: query)
            fetchedResultsController?.delegate = self
            try fetchedResultsController?.performFetch()
            sendObjects(fetchedObjects: fetchedResultsController?.fetchedObjects)
        } catch {
            output?.didFailToObserveItems(error)
        }
    }

    func syncRemoteDataIfNeeded() {
        if firstLaunchService.checkIsFirstLaunch() {
            toDoRepository.refresh { [weak self] result in
                if case let Result.failure(error) = result {
                    self?.output?.didFailToSyncItems(error)
                }
            }
        }
    }

    func sendObjects(fetchedObjects: [ToDoEntity]?) {
        if let items = fetchedObjects?.mapToDomain() {
            output?.didUpdateItems(items)
        }
    }
}
