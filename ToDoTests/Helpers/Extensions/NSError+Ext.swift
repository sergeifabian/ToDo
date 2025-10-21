//
//  NSError+Ext.swift
//  ToDo
//
//  Created by Sergei Fabian on 21.10.2025.
//

import Foundation

extension NSError {
    static let stringEncoding = NSError(domain: "CustomError", code: 1000)
    static let httpURLResponseBuilding = NSError(domain: "CustomError", code: 1100)
    static let mockSettings = NSError(domain: "CustomError", code: 1200)
}
