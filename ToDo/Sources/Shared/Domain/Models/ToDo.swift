//
//  ToDo.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

struct ToDo: Identifiable {
    let id: String
    let title: String?
    let details: String?
    let completed: Bool
    let date: Date

    func updating(title: String) -> ToDo {
        ToDo(id: id, title: title, details: details, completed: completed, date: date)
    }

    func updating(details: String) -> ToDo {
        ToDo(id: id, title: title, details: details, completed: completed, date: date)
    }
}

extension ToDo {
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
