//
//  ToDoPersistenceDTO.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

struct ToDoPersistenceDTO {
    let id: String
    let title: String?
    let details: String?
    let completed: Bool
    let date: Date?

    static func mapFromDomain(_ model: ToDo) -> ToDoPersistenceDTO {
        ToDoPersistenceDTO(
            id: model.id,
            title: model.title,
            details: model.details,
            completed: model.completed,
            date: model.date
        )
    }
}
