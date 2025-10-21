//
//  MockedError.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation

enum MockedError: Error {
    case urlBuilder
    case urlRequestExecutor
    case httpResponseValidator
    case httpResponseParser
}
