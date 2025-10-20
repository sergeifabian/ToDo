//
//  DependenciesContainer.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

final class DependenciesContainer {

    let urlSession = URLSession.shared
    let userDefaults = UserDefaults.standard
    let jsonDecoder = JSONDecoder()

    let networkClient: NetworkClient
    let databaseClient: DatabaseClient

    init() {
        let urlBuilder = URLBuilderImpl()
        let urlRequestBuilder = URLRequestBuilderImpl(urlBuilder: urlBuilder)
        let urlRequestExecutor = URLRequestExecutorImpl(urlSession: urlSession)
        let httpResponseValidator = HTTPResponseValidatorImpl()
        let httpResponseParser = HTTPResponseParserImpl(jsonDecoder: jsonDecoder)

        networkClient = NetworkClientImpl(
            urlRequestBuilder: urlRequestBuilder,
            urlRequestExecutor: urlRequestExecutor,
            httpResponseValidator: httpResponseValidator,
            httpResponseParser: httpResponseParser
        )

        databaseClient = DatabaseClientImpl()
    }

    var toDoLocalDataSource: ToDoLocalDataSource {
        ToDoLocalDataSourceImpl(databaseClient: databaseClient)
    }

    var toDoRemoteDataSource: ToDoRemoteDataSource {
        ToDoRemoteDataSourceImpl(networkClient: networkClient)
    }

    var toDoRepository: ToDoRepository {
        ToDoRepositoryImpl(toDoLocalDataSource: toDoLocalDataSource, toDoRemoteDataSource: toDoRemoteDataSource)
    }

    var firstLaunchService: FirstLaunchService {
        FirstLaunchServiceImpl(userDefaults: userDefaults)
    }

    var toDoObservationService: ToDoObservationService {
        ToDoObservationServiceImpl(toDoLocalDataSource: toDoLocalDataSource)
    }
}

extension DependenciesContainer: ToDoListDependencies {}

extension DependenciesContainer: ToDoBuilderDependencies {}
