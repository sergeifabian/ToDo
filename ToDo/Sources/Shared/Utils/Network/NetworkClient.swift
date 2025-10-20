//
//  NetworkClient.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol NetworkClient {
    func request<E: HTTPEndpoint, V: Decodable>(_ endpoint: E,  completion: @escaping ResultClosure<V>)
}

final class NetworkClientImpl: NetworkClient {
    private let urlRequestBuilder: URLRequestBuilder
    private let urlRequestExecutor: URLRequestExecutor
    private let httpResponseValidator: HTTPResponseValidator
    private let httpResponseParser: HTTPResponseParser

    init(
        urlRequestBuilder: URLRequestBuilder,
        urlRequestExecutor: URLRequestExecutor,
        httpResponseValidator: HTTPResponseValidator,
        httpResponseParser: HTTPResponseParser
    ) {
        self.urlRequestBuilder = urlRequestBuilder
        self.urlRequestExecutor = urlRequestExecutor
        self.httpResponseValidator = httpResponseValidator
        self.httpResponseParser = httpResponseParser
    }

    func request<E: HTTPEndpoint, V: Decodable>(_ endpoint: E, completion: @escaping ResultClosure<V>) {
        requestInternal(endpoint) { [weak self] result in
            guard let self else { return }

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
            let urlRequest = try urlRequestBuilder.build(endpoint: endpoint)

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
