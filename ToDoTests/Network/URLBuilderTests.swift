//
//  URLBuilderTests.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import XCTest
@testable import ToDo

final class URLBuilderTests: XCTestCase {
    private let urlBuilderSUT = URLBuilderImpl()

    func testBuildSuccess() throws {
        struct Endpoint: HTTPEndpoint {
            let path = "/todos"
        }

        let endpoint = Endpoint()

        let resultURL = try urlBuilderSUT.build(endpoint: endpoint)

        var urlComponents = URLComponents()
        urlComponents.scheme = UIApplication.domainScheme
        urlComponents.host = UIApplication.domainHost
        urlComponents.path = endpoint.path

        let expectedURL = try XCTUnwrap(urlComponents.url)

        XCTAssertEqual(resultURL.absoluteString, expectedURL.absoluteString)
    }

    func testBuildFailure() {
        struct Endpoint: HTTPEndpoint {
            let path = "💥 invalid path"
        }

        let endpoint = Endpoint()

        XCTAssertThrowsError(try urlBuilderSUT.build(endpoint: endpoint)) { error in
            XCTAssertEqual(error.asUrlError?.code, .badURL)
        }
    }
}

