//
//  NetworkClient.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public protocol NetworkClient {
    func request<E: HTTPEndpoint, V: Decodable>(_ endpoint: E, type: V.Type, completion: @escaping ResultClosure<V>)
}

public extension NetworkClient {
    func request<E: HTTPEndpoint, V: Decodable>(_ endpoint: E, completion: @escaping ResultClosure<V>) {
        request(endpoint, type: V.self, completion: completion)
    }
}

public struct NetworkClientImpl: NetworkClient {
    private let urlBuilder: URLBuilder
    private let urlRequestExecutor: URLRequestExecutor
    private let httpResponseValidator: HTTPResponseValidator
    private let httpResponseParser: HTTPResponseParser

    public init(
        urlBuilder: URLBuilder,
        urlRequestExecutor: URLRequestExecutor,
        httpResponseValidator: HTTPResponseValidator,
        httpResponseParser: HTTPResponseParser
    ) {
        self.urlBuilder = urlBuilder
        self.urlRequestExecutor = urlRequestExecutor
        self.httpResponseValidator = httpResponseValidator
        self.httpResponseParser = httpResponseParser
    }

    public func request<E: HTTPEndpoint, V: Decodable>(
        _ endpoint: E,
        type: V.Type,
        completion: @escaping ResultClosure<V>
    ) {
        requestInternal(endpoint) { result in
            do {
                switch result {
                case .success(let response):
                    try httpResponseValidator.validate(response: response)
                    try completion(.success(httpResponseParser.parse(from: response)))
                case .failure(let error):
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    private func requestInternal<E: HTTPEndpoint>(_ endpoint: E, completion: @escaping ResultClosure<HTTPResponse>) {
        do {
            let url = try urlBuilder.build(endpoint: endpoint)
            let urlRequest = URLRequest(url: url, httpMethod: endpoint.httpMethod)

            urlRequestExecutor.execute(request: urlRequest) { result in
                switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
