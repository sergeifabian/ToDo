//
//  HTTPResponseValidatorTests.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import XCTest
@testable import ToDo

final class HTTPResponseValidatorTests: XCTestCase {
    private let httpResponseValidatorSUT = HTTPResponseValidatorImpl()

    func testValidateSuccess2xx() throws {
        let httpResponse = try XCTUnwrap(HTTPResponse.createMockedResponse(statusCode: .ok))

        XCTAssertNoThrow(try httpResponseValidatorSUT.validate(response: httpResponse))
    }

    func testValidateFailure3xx() throws {
        let httpResponse = try XCTUnwrap(HTTPResponse.createMockedResponse(statusCode: .multipleChoices))

        XCTAssertThrowsError(try httpResponseValidatorSUT.validate(response: httpResponse)) { error in
            XCTAssertEqual(error.asUrlError?.code, .badServerResponse)
        }
    }

    func testValidateFailure4xx() throws {
        let httpResponse = try XCTUnwrap(HTTPResponse.createMockedResponse(statusCode: .badRequest))

        XCTAssertThrowsError(try httpResponseValidatorSUT.validate(response: httpResponse)) { error in
            XCTAssertEqual(error.asUrlError?.code, .badServerResponse)
        }
    }

    func testValidateFailure5xx() throws {
        let httpResponse = try XCTUnwrap(HTTPResponse.createMockedResponse(statusCode: .internalServerError))

        XCTAssertThrowsError(try httpResponseValidatorSUT.validate(response: httpResponse)) { error in
            XCTAssertEqual(error.asUrlError?.code, .badServerResponse)
        }
    }

    func testValidateBoundaries() throws {
        struct Boundary {
            let statusCode: Int
            let shouldPass: Bool
        }

        let boundaries = [
            Boundary(statusCode: 199, shouldPass: false),
            Boundary(statusCode: 200, shouldPass: true),
            Boundary(statusCode: 299, shouldPass: true),
            Boundary(statusCode: 300, shouldPass: false),
        ]

        for boundary in boundaries {
            let httpResponse = try XCTUnwrap(HTTPResponse.createMockedResponse(statusCode: boundary.statusCode))

            if boundary.shouldPass {
                XCTAssertNoThrow(try httpResponseValidatorSUT.validate(response: httpResponse))
            } else {
                XCTAssertThrowsError(try httpResponseValidatorSUT.validate(response: httpResponse)) { error in
                    XCTAssertEqual(error.asUrlError?.code, .badServerResponse)
                }
            }
        }
    }
}
