//
//  HTTPResponseParser.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public protocol HTTPResponseParser {
    func parse<T: Decodable>(_ type: T.Type, from response: HTTPResponse) throws -> T
}

public extension HTTPResponseParser {
    func parse<T: Decodable>(from response: HTTPResponse) throws -> T {
        try parse(T.self, from: response)
    }
}

public struct HTTPResponseParserImpl: HTTPResponseParser {
    private let jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder) {
        self.jsonDecoder = jsonDecoder
    }

    public func parse<T: Decodable>(_ type: T.Type, from response: HTTPResponse) throws -> T {
        do {
            return try jsonDecoder.decode(type, from: response.data)
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
