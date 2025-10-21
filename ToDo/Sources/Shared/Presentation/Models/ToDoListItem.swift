//
//  ToDoListItem.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

public nonisolated struct ToDoListItem: Hashable, Sendable {
    public let id: String
    public let title: String?
    public let details: String?
    public let completed: Bool
    public let date: String

    public init(id: String, title: String?, details: String?, completed: Bool, date: String) {
        self.id = id
        self.title = title
        self.details = details
        self.completed = completed
        self.date = date
    }

    public static func mapFromDomain(_ model: ToDo) -> ToDoListItem {
        ToDoListItem(
            id: model.id,
            title: model.title,
            details: model.details,
            completed: model.completed,
            date: model.date.formatted(date: .numeric, time: .omitted)
        )
    }
}

public extension ToDoListItem {
    static var initial: ToDoListItem {
        ToDoListItem(
            id: String(),
            title: nil,
            details: nil,
            completed: false,
            date: Date.now.formatted(date: .numeric, time: .omitted)
        )
    }
}
