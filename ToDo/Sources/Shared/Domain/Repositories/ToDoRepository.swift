//
//  ToDoRepository.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol HasToDoRepository {
    var toDoRepository: ToDoRepository { get }
}

protocol ToDoRepository {
    func refresh(completion: @escaping ResultClosure<Void>)
    func toggle(id: String, completion: @escaping ResultClosure<Void>)
    func fetch(id: String, completion: @escaping ResultClosure<ToDo?>)
    func delete(id: String, completion: @escaping ResultClosure<Void>)
    func upsert(dto: ToDoPersistenceDTO, completion: @escaping ResultClosure<Void>)
}

final class ToDoRepositoryImpl: ToDoRepository {
    private let toDoLocalDataSource: ToDoLocalDataSource
    private let toDoRemoteDataSource: ToDoRemoteDataSource

    init(toDoLocalDataSource: ToDoLocalDataSource, toDoRemoteDataSource: ToDoRemoteDataSource) {
        self.toDoLocalDataSource = toDoLocalDataSource
        self.toDoRemoteDataSource = toDoRemoteDataSource
    }

    func refresh(completion: @escaping ResultClosure<Void>) {
        toDoRemoteDataSource.fetch { [weak self] result in
            switch result {
            case .success(let dto):
                let persistenceItems = dto.todos.mapToPersistenceDto()
                self?.toDoLocalDataSource.upsert(persistenceItems, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func toggle(id: String, completion: @escaping ResultClosure<Void>) {
        toDoLocalDataSource.toggle(id: id, completion: completion)
    }

    func fetch(id: String, completion: @escaping ResultClosure<ToDo?>) {
        toDoLocalDataSource.fetch(id: id) { result in
            switch result {
            case .success(let entity):
                completion(.success(entity?.mapToDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func delete(id: String, completion: @escaping ResultClosure<Void>) {
        toDoLocalDataSource.delete(id: id, completion: completion)
    }

    func upsert(dto: ToDoPersistenceDTO, completion: @escaping ResultClosure<Void>) {
        toDoLocalDataSource.upsert([dto], completion: completion)
    }
}
