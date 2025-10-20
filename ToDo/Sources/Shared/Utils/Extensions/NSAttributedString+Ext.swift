//
//  NSAttributedString+Ext.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

extension NSAttributedString {
    var isEmpty: Bool {
        string.isEmpty
    }
}

extension Optional where Wrapped: NSAttributedString {
    var orEmpty: NSAttributedString {
        self ?? NSAttributedString()
    }
}
