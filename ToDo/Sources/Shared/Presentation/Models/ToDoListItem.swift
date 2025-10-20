//
//  ToDoListItem.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

nonisolated struct ToDoListItem: Hashable, Sendable {
    let id: String
    let title: String?
    let details: String?
    let completed: Bool
    let date: String

    static func mapFromDomain(_ model: ToDo) -> ToDoListItem {
        ToDoListItem(
            id: model.id,
            title: model.title,
            details: model.details,
            completed: model.completed,
            date: model.date.formatted(date: .numeric, time: .omitted)
        )
    }
}

extension ToDoListItem {
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
