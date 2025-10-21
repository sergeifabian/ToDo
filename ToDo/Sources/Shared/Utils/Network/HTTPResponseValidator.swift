//
//  HTTPResponseValidator.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public protocol HTTPResponseValidator {
    func validate(response: HTTPResponse) throws
}

public struct HTTPResponseValidatorImpl: HTTPResponseValidator {
    public func validate(response: HTTPResponse) throws {
        guard HTTPStatusCode.acceptableStatusCodes.contains(response.httpURLResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
