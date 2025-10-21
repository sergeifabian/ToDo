//
//  ToDo.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public struct ToDo: Identifiable {
    public let id: String
    public let title: String?
    public let details: String?
    public let completed: Bool
    public let date: Date

    public func updating(title: String) -> ToDo {
        ToDo(id: id, title: title, details: details, completed: completed, date: date)
    }

    public func updating(details: String) -> ToDo {
        ToDo(id: id, title: title, details: details, completed: completed, date: date)
    }
}

public extension ToDo {
    static var initial: ToDo {
        ToDo(
            id: UUID().uuidString,
            title: nil,
            details: nil,
            completed: false,
            date: Date.now
        )
    }
}
