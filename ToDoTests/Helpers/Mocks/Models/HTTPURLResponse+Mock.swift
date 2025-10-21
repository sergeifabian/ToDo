//
//  HTTPURLResponse+Mock.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation
import ToDo

extension HTTPURLResponse {
    static func createMockedResponse(statusCode: HTTPStatusCode) throws -> HTTPURLResponse {
        try createMockedResponse(statusCode: statusCode.rawValue)
    }

    static func createMockedResponse(statusCode: Int) throws -> HTTPURLResponse {
        guard let response = try HTTPURLResponse(
            url: URL.createMock(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        ) else {
            throw NSError.httpURLResponseBuilding
        }

        return response
    }
}
