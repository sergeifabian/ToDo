//
//  ToDoBuilderPresenter.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

final class ToDoBuilderPresenter {

    var interactor: ToDoBuilderInteractor?

    weak var view: ToDoBuilderView?
}

// MARK: - ToDoBuilderViewOutput

extension ToDoBuilderPresenter: ToDoBuilderViewOutput {
    func viewDidLoad() {
        interactor?.fetchInitialData()
    }

    func viewWillDisappear() {
        interactor?.saveDataIfNeeded()
    }

    func titleDidChange(_ title: String) {
        interactor?.fillTitle(title)
    }

    func detailsDidChange(_ details: String) {
        interactor?.fillDetails(details)
    }
}

// MARK: - ToDoBuilderInteractorOutput

extension ToDoBuilderPresenter: ToDoBuilderInteractorOutput {
    func didFetch(_ item: ToDo) {
        DispatchQueue.main.async {
            self.view?.setItem(ToDoListItem.mapFromDomain(item))
        }
    }

    func didFailToFetch(_ error: any Error) {
        // FIXME: Additional requirements required
    }

    func didFailToUpsert(_ error: any Error) {
        // FIXME: Additional requirements required
    }
}
