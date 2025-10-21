//
//  MockedURLBuilder.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation
import ToDo

final class MockedURLBuilder: URLBuilder {
    var builtEndpoints: [HTTPEndpoint] = []

    private let result: Result<URL, Error>

    init(result: Result<URL, Error>) {
        self.result = result
    }

    func build<E: HTTPEndpoint>(endpoint: E) throws -> URL {
        builtEndpoints.append(endpoint)
        return try result.get()
    }
}
