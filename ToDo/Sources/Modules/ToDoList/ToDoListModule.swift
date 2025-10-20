//
//  ToDoListModule.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

protocol ToDoListModuleFactory {
    func makeListModule() -> UIViewController
}

enum ToDoListModule {
    static func build(
        dependencies: ToDoListDependencies,
        toDoBuilderModuleFactory: ToDoBuilderModuleFactory
    ) -> UIViewController {
        let view = ToDoListViewController()
        let navigation = BaseNavigationController(rootViewController: view)

        let router = ToDoListRouterImpl(toDoBuilderModuleFactory: toDoBuilderModuleFactory)

        let presenter = ToDoListPresenter()

        let interactor = ToDoListInteractorImpl(
            toDoRepository: dependencies.toDoRepository,
            firstLaunchService: dependencies.firstLaunchService,
            toDoObservationService: dependencies.toDoObservationService
        )

        view.output = presenter

        router.viewController = view
        router.navigationController = navigation

        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor

        interactor.output = presenter

        return navigation
    }
}
