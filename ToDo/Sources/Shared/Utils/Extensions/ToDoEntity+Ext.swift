//
//  ToDoEntity+Ext.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

extension ToDoEntity {
    func mapToDomain() -> ToDo? {
        guard let id = identifier, let date else { return nil }
        return ToDo(id: id, title: title, details: details, completed: completed, date: date)
    }
}

extension Array where Element: ToDoEntity {
    func mapToDomain() -> [ToDo] {
        compactMap { entity in
            entity.mapToDomain()
        }
    }
}
