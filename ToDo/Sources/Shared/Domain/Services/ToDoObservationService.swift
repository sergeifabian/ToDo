//
//  ToDoObservationService.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation
import CoreData

protocol HasToDoObservationService {
    var toDoObservationService: ToDoObservationService { get }
}

protocol ToDoObservationService {
    func createFetchedResultsController(query: String?) -> NSFetchedResultsController<ToDoEntity>
}

final class ToDoObservationServiceImpl: ToDoObservationService {
    private let toDoLocalDataSource: ToDoLocalDataSource

    init(toDoLocalDataSource: ToDoLocalDataSource) {
        self.toDoLocalDataSource = toDoLocalDataSource
    }

    func createFetchedResultsController(query: String?) -> NSFetchedResultsController<ToDoEntity> {
        toDoLocalDataSource.createFetchedResultsController(query: query)
    }
}
