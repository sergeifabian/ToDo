//
//  URLRequest+Ext.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

extension URLRequest {
    init(url: URL, httpMethod: HTTPMethod) {
        self.init(url: url)
        self.httpMethod = httpMethod.rawValue
    }
}
