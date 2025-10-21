//
//  HTTPStatusCode.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public enum HTTPStatusCode: Int {
    case ok = 200
    case multipleChoices = 300
    case badRequest = 400
    case internalServerError = 500

    public static let acceptableStatusCodes = 200 ..< 300
}
