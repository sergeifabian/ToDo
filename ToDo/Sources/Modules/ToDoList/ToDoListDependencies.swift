//
//  ToDoListDependencies.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol ToDoListDependencies: HasToDoRepository, HasFirstLaunchService, HasToDoObservationService {}
