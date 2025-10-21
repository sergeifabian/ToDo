//
//  URLBuilder.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

public protocol URLBuilder {
    func build<E: HTTPEndpoint>(endpoint: E) throws -> URL
}

public struct URLBuilderImpl: URLBuilder {
    public init() {}

    public func build<E: HTTPEndpoint>(endpoint: E) throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = UIApplication.domainScheme
        urlComponents.host = UIApplication.domainHost
        urlComponents.path = endpoint.path

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        return url
    }
}
