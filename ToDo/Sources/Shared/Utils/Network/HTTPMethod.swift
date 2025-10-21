//
//  HTTPMethod.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public struct HTTPMethod: RawRepresentable {
    public static let get = HTTPMethod(rawValue: "GET")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}
