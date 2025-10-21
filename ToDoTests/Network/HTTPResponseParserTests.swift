//
//  HTTPResponseParserTests.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import XCTest
@testable import ToDo

final class HTTPResponseParserTests: XCTestCase {
    private struct ToDo: Decodable {
        let id: Int
        let title: String
    }

    private let httpResponseParserSUT = HTTPResponseParserImpl(jsonDecoder: JSONDecoder())

    func testParseSuccess() throws {
        let json = #"{ "id": 1, "title": "Title" }"#
        let jsonData = try json.encode(using: .utf8)
        let httpResponse = try HTTPResponse.createMockedResponse(data: jsonData, statusCode: .ok)

        let model = try httpResponseParserSUT.parse(ToDo.self, from: httpResponse)

        XCTAssertEqual(model.id, 1)
        XCTAssertEqual(model.title, "Title")
    }

    func testParseFailure() throws {
        let json = #"{ "id": "💥 invalid id" }"#
        let jsonData = try json.encode(using: .utf8)
        let httpResponse = try HTTPResponse.createMockedResponse(data: jsonData, statusCode: .ok)

        XCTAssertThrowsError(try httpResponseParserSUT.parse(ToDo.self, from: httpResponse)) { error in
            XCTAssertEqual(error.asUrlError?.code, .cannotParseResponse)
        }
    }
}
