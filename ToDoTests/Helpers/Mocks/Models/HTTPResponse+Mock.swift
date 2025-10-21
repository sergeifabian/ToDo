//
//  HTTPResponse+Mocks.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation
import ToDo

extension HTTPResponse {
    static func createMockedResponse(data: Data = Data(), statusCode: HTTPStatusCode) throws -> HTTPResponse {
        try createMockedResponse(data: data, statusCode: statusCode.rawValue)
    }

    static func createMockedResponse(data: Data = Data(), statusCode: Int) throws -> HTTPResponse {
        try HTTPResponse(data: data, httpURLResponse: HTTPURLResponse.createMockedResponse(statusCode: statusCode))
    }
}
