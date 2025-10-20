//
//  ToDoRemoteDataSource.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol HasToDoRemoteDataSource {
    var toDoRemoteDataSource: ToDoRemoteDataSource { get }
}

protocol ToDoRemoteDataSource {
    func fetch(completion: @escaping ResultClosure<ToDoListDTO>)
}

final class ToDoRemoteDataSourceImpl: ToDoRemoteDataSource {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetch(completion: @escaping ResultClosure<ToDoListDTO>) {
        networkClient.request(ToDoEndpoint(), completion: completion)
    }
}
