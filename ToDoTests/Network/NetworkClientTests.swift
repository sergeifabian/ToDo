//
//  NetworkClientTests.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import XCTest
@testable import ToDo

@MainActor
final class NetworkClientTests: XCTestCase {
    private struct Endpoint: HTTPEndpoint {
        let path = "/todos/1"
    }

    private struct ToDo: Decodable {
        let id: Int
    }

    private let model = ToDo(id: 1)
    private let modelJSON = #"{ "id": "1" }"#

    func testRequestSuccessFlow() throws {
        let networkClientSUT = try createNetworkClientSUT()

        let expected = expectation(description: String(describing: ToDo.self))

        networkClientSUT.request(Endpoint(), type: ToDo.self) { result in
            switch result {
            case .success(let toDo):
                XCTAssertEqual(toDo.id, 1)
            case .failure(let error):
                XCTFail("Expected success. Got error: \(error)")
            }

            expected.fulfill()
        }

        wait(for: [expected], timeout: 1)
    }

    func testRequestPropagatesBuilderFailure() throws {
        let expectedError = MockedError.urlBuilder
        let networkClientSUT = try createNetworkClientSUT(urlBuilderResult: .failure(expectedError))
        try validateExpectedError(expectedError, for: networkClientSUT)
    }

    func testRequestPropagatesExecutorFailure() throws {
        let expectedError = MockedError.urlRequestExecutor
        let networkClientSUT = try createNetworkClientSUT(urlRequestExecutorResult: .failure(expectedError))
        try validateExpectedError(expectedError, for: networkClientSUT)
    }

    func testRequestPropagatesValidatorFailure() throws {
        let expectedError = MockedError.httpResponseValidator
        let networkClientSUT = try createNetworkClientSUT(httpResponseValidatorResult: .failure(expectedError))
        try validateExpectedError(expectedError, for: networkClientSUT)
    }

    func testRequestPropagatesParserFailure() throws {
        let expectedError = MockedError.httpResponseParser
        let networkClientSUT = try createNetworkClientSUT(httpResponseParserResult: .failure(expectedError))
        try validateExpectedError(expectedError, for: networkClientSUT)
    }
}

private extension NetworkClientTests {
    func createNetworkClientSUT(
        urlBuilderResult: Result<URL, Error>? = nil,
        urlRequestExecutorResult: Result<HTTPResponse, Error>? = nil,
        httpResponseValidatorResult: Result<Void, Error>? = nil,
        httpResponseParserResult: Result<Any, Error>? = nil
    ) throws -> NetworkClient {
        let urlBuilder = try MockedURLBuilder(
            result: urlBuilderResult ?? createFallbackURLBuilderResult()
        )

        let urlRequestExecutor = try MockedURLRequestExecutor(
            result: urlRequestExecutorResult ?? createFallbackURLRequestExecutorResult()
        )

        let httpResponseValidator = MockedHTTPResponseValidator(
            result: httpResponseValidatorResult ?? .success(())
        )

        let httpResponseParser = MockedHTTPResponseParser(
            result: httpResponseParserResult ?? .success(model)
        )

        return NetworkClientImpl(
            urlBuilder: urlBuilder,
            urlRequestExecutor: urlRequestExecutor,
            httpResponseValidator: httpResponseValidator,
            httpResponseParser: httpResponseParser
        )
    }

    func createFallbackURLBuilderResult() throws -> Result<URL, Error> {
        let url = try URL.createMock()
        return .success(url)
    }

    func createFallbackURLRequestExecutorResult() throws -> Result<HTTPResponse, Error> {
        let jsonData = try modelJSON.encode(using: .utf8)
        let httpResponse = try HTTPResponse.createMockedResponse(data: jsonData, statusCode: .ok)
        return .success(httpResponse)
    }

    func validateExpectedError(_ expectedError: MockedError, for networkClientSUT: NetworkClient) throws {
        let expected = expectation(description: String(describing: expectedError))

        networkClientSUT.request(Endpoint(), type: ToDo.self) { result in
            switch result {
            case .success(let toDo):
                XCTFail("Expected failure. Got model: \(toDo)")
            case .failure(let error):
                XCTAssertEqual(error.asMockedError, expectedError)
            }

            expected.fulfill()
        }

        wait(for: [expected], timeout: 1)
    }
}
