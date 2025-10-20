//
//  URLRequestExecutor.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol URLRequestExecutor {
    func execute(request: URLRequest, completion: @escaping ResultClosure<HTTPResponse>)
}

final class URLRequestExecutorImpl: URLRequestExecutor {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func execute(request: URLRequest, completion: @escaping ResultClosure<HTTPResponse>) {
        let task = urlSession.dataTask(with: request) { data, urlResponse, error in
            if let error {
                completion(.failure(error))
            } else if let data, let httpURLResponse = urlResponse as? HTTPURLResponse {
                completion(.success(HTTPResponse(data: data, httpURLResponse: httpURLResponse)))
            } else {
                completion(.failure(URLError(.badServerResponse)))
            }
        }

        task.resume()
    }
}
