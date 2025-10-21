//
//  MockedURLRequestExecutor.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation
import ToDo

final class MockedURLRequestExecutor: URLRequestExecutor {
    var executedRequests: [URLRequest] = []

    private let result: Result<HTTPResponse, Error>

    init(result: Result<HTTPResponse, Error>) {
        self.result = result
    }

    func execute(request: URLRequest, completion: @escaping ResultClosure<HTTPResponse>) {
        executedRequests.append(request)
        completion(result)
    }
}
