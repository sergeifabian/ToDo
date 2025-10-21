//
//  URL+Mock.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation

extension URL {
    static func createMock() throws -> URL {
        guard let url = URL(string: "https://domain.website") else {
            throw URLError(.badURL)
        }

        return url
    }
}
