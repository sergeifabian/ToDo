//
//  ToDoBuilderModule.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

protocol ToDoBuilderModuleFactory {
    func makeBuilderModule(input: ToDoBuilderModuleInput) -> UIViewController
}

enum ToDoBuilderModule {
    static func build(input: ToDoBuilderModuleInput, dependencies: ToDoBuilderDependencies) -> UIViewController {
        let view =  ToDoBuilderViewController()
        let presenter = ToDoBuilderPresenter()
        let interactor = ToDoBuilderInteractorImpl(input: input, toDoRepository: dependencies.toDoRepository)

        view.output = presenter

        presenter.view = view
        presenter.interactor = interactor

        interactor.output = presenter

        return view
    }
}
