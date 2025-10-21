//
//  HTTPResponse.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public struct HTTPResponse {
    public let data: Data
    public let httpURLResponse: HTTPURLResponse

    public init(data: Data, httpURLResponse: HTTPURLResponse) {
        self.data = data
        self.httpURLResponse = httpURLResponse
    }
}
