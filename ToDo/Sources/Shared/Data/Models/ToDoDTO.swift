//
//  ToDoDTO.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

struct ToDoDTO: Decodable {
    let id: Int
    let todo: String
    let completed: Bool

    func mapToPersistenceDto() -> ToDoPersistenceDTO {
        ToDoPersistenceDTO(
            id: String(id),
            title: String(id),
            details: todo,
            completed: completed,
            date: nil
        )
    }
}

extension Array where Element == ToDoDTO {
    func mapToPersistenceDto() -> [ToDoPersistenceDTO] {
        map { dto in
            dto.mapToPersistenceDto()
        }
    }
}
