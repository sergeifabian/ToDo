//
//  String+Ext.swift
//  ToDoTests
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation

extension String {
    func encode(using encoding: String.Encoding) throws -> Data {
        if let data = data(using: encoding) {
            return data
        } else {
            throw NSError.stringEncoding
        }
    }
}
