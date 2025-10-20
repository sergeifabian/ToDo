//
//  ToDoListDTO.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

struct ToDoListDTO: Decodable {
    let todos: [ToDoDTO]
}
