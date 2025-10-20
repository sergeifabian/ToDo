//
//  ToDoRouter.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

protocol ToDoListRouter: AnyObject {
    func create()
    func update(id: String)
}

final class ToDoListRouterImpl: ToDoListRouter {

    weak var viewController: UIViewController?
    weak var navigationController: UINavigationController?

    private let toDoBuilderModuleFactory: ToDoBuilderModuleFactory

    init(toDoBuilderModuleFactory: ToDoBuilderModuleFactory) {
        self.toDoBuilderModuleFactory = toDoBuilderModuleFactory
    }

    func create() {
        showBuilder(input: .create)
    }

    func update(id: String) {
        showBuilder(input: .update(id: id))
    }
}

// MARK: - Utils

private extension ToDoListRouterImpl {
    func showBuilder(input: ToDoBuilderModuleInput) {
        let viewController = toDoBuilderModuleFactory.makeBuilderModule(input: input)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
