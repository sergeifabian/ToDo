//
//  ToDoBuilderInteractor.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol ToDoBuilderInteractor: AnyObject {
    func fetchInitialData()
    func saveDataIfNeeded()
    func fillTitle(_ title: String)
    func fillDetails(_ details: String)
}

protocol ToDoBuilderInteractorOutput: AnyObject {
    func didFetch(_ item: ToDo)
    func didFailToFetch(_ error: Error)
    func didFailToUpsert(_ error: Error)
}

final class ToDoBuilderInteractorImpl {

    weak var output: ToDoBuilderInteractorOutput?

    // MARK: - Data

    private var cachedToDo: ToDo?
    private var currentToDo: ToDo?

    // MARK: - Input

    private let input: ToDoBuilderModuleInput

    // MARK: - Dependencies

    private let toDoRepository: ToDoRepository

    // MARK: - Lifecycle

    init(input: ToDoBuilderModuleInput, toDoRepository: ToDoRepository) {
        self.input = input
        self.toDoRepository = toDoRepository
    }
}

// MARK: - ToDoBuilderInteractor

extension ToDoBuilderInteractorImpl: ToDoBuilderInteractor {
    func fetchInitialData() {
        switch input {
        case .create:
            let initialToDo = ToDo.initial
            currentToDo = initialToDo
            output?.didFetch(initialToDo)
        case .update(id: let id):
            toDoRepository.fetch(id: id) { [weak self] result in
                switch result {
                case .success(let toDo):
                    if let toDo {
                        self?.cachedToDo = toDo
                        self?.currentToDo = toDo
                        self?.output?.didFetch(toDo)
                    } else {
                        self?.output?.didFetch(.initial)
                    }
                case .failure(let error):
                    self?.output?.didFailToFetch(error)
                }
            }
        }
    }

    func saveDataIfNeeded() {
        if let cachedToDo {
            saveDataIfChanged(cached: cachedToDo, current: currentToDo)
        } else {
            saveDataIfFilled(current: currentToDo)
        }
    }

    func fillTitle(_ title: String) {
        currentToDo = currentToDo?.updating(title: title)
    }

    func fillDetails(_ details: String) {
        currentToDo = currentToDo?.updating(details: details)
    }
}

// MARK: - Utils

private extension ToDoBuilderInteractorImpl {
    func saveDataIfChanged(cached: ToDo?, current: ToDo?) {
        guard let cached, let current else { return }

        if cached.title != current.title || cached.details != current.details {
            save(dto: ToDoPersistenceDTO.mapFromDomain(current))
        }
    }

    func saveDataIfFilled(current: ToDo?) {
        guard let current else { return }

        if current.title.orEmpty.isNotEmpty || current.details.orEmpty.isNotEmpty {
            save(dto: ToDoPersistenceDTO.mapFromDomain(current))
        }
    }

    func save(dto: ToDoPersistenceDTO) {
        toDoRepository.upsert(dto: dto) { [weak self] result in
            if case let Result.failure(error) = result {
                self?.output?.didFailToUpsert(error)
            }
        }
    }
}
