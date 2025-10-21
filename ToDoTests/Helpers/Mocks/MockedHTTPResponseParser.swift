//
//  MockedHTTPResponseParser.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation
import ToDo

final class MockedHTTPResponseParser: HTTPResponseParser {
    var parsedResponses: [HTTPResponse] = []

    private let result: Result<Any, Error>

    init(result: Result<Any, Error>) {
        self.result = result
    }

    func parse<T: Decodable>(_ type: T.Type, from response: HTTPResponse) throws -> T {
        parsedResponses.append(response)

        guard let value = try result.get() as? T else {
            throw NSError.mockSettings
        }

        return value
    }
}
