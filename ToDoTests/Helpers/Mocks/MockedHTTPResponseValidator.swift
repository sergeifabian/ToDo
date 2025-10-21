//
//  MockedHTTPResponseValidator.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation
import ToDo

final class MockedHTTPResponseValidator: HTTPResponseValidator {
    var validatedResponses: [HTTPResponse] = []

    private let result: Result<Void, Error>

    init(result: Result<Void, Error>) {
        self.result = result
    }

    func validate(response: HTTPResponse) throws {
        validatedResponses.append(response)
        try result.get()
    }
}
