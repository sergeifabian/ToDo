//
//  Any+Ext.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

extension NSObject {
    static var className: String {
        String(describing: self)
    }

    var className: String {
        String(describing: type(of: self))
    }
}
