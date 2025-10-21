//
//  Error+Ext.swift
//  ToDo
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation

extension Error {
    var asUrlError: URLError? {
        self as? URLError
    }

    var asMockedError: MockedError? {
        self as? MockedError
    }
}
