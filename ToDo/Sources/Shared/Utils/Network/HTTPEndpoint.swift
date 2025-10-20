//
//  HTTPEndpoint.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol HTTPEndpoint {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}

extension HTTPEndpoint {
    var httpMethod: HTTPMethod { .get }
}
