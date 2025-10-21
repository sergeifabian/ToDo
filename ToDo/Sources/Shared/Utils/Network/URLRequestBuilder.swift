//
//  HTTPRequestBuilder.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public protocol URLRequestBuilder {
    func build<E: HTTPEndpoint>(endpoint: E) throws -> URLRequest
}

public final class URLRequestBuilderImpl: URLRequestBuilder {
    private let urlBuilder: URLBuilder

    public init(urlBuilder: URLBuilder) {
        self.urlBuilder = urlBuilder
    }

    public func build<E: HTTPEndpoint>(endpoint: E) throws -> URLRequest {
        try URLRequest(url: urlBuilder.build(endpoint: endpoint), httpMethod: endpoint.httpMethod)
    }
}
