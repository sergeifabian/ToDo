//
//  HTTPMethod.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

struct HTTPMethod: RawRepresentable {
    static let get = HTTPMethod(rawValue: "GET")

    let rawValue: String
}
