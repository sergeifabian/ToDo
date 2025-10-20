//
//  FactoriesContainer.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

final class FactoriesContainer {
    let dependencies: DependenciesContainer

    init(dependencies: DependenciesContainer) {
        self.dependencies = dependencies
    }
}

extension FactoriesContainer: ToDoListModuleFactory {
    func makeListModule() -> UIViewController {
        ToDoListModule.build(dependencies: dependencies, toDoBuilderModuleFactory: self)
    }
}

extension FactoriesContainer: ToDoBuilderModuleFactory {
    func makeBuilderModule(input: ToDoBuilderModuleInput) -> UIViewController {
        ToDoBuilderModule.build(input: input, dependencies: dependencies)
    }
}
