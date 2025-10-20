//
//  HTTPRequestBuilder.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol URLRequestBuilder {
    func build<E: HTTPEndpoint>(endpoint: E) throws -> URLRequest
}

final class URLRequestBuilderImpl: URLRequestBuilder {
    private let urlBuilder: URLBuilder

    init(urlBuilder: URLBuilder) {
        self.urlBuilder = urlBuilder
    }

    func build<E: HTTPEndpoint>(endpoint: E) throws -> URLRequest {
        try URLRequest(url: urlBuilder.build(endpoint: endpoint), httpMethod: endpoint.httpMethod)
    }
}
