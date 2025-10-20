//
//  String+Ext.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? String()
    }
}
