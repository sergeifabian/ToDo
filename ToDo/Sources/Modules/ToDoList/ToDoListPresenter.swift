//
//  ToDoListPresenter.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

final class ToDoListPresenter {

    var interactor: ToDoListInteractor?

    weak var view: ToDoListView?

    var router: ToDoListRouter?

    private let debouncer = Debouncer(delay: Constant.debouncerDelay)
}

extension ToDoListPresenter: ToDoListViewOutput {

    func viewDidLoad() {
        view?.setIntialDataLoading()
        interactor?.fetchInitialData()
    }

    func searchDidChange(query: String) {
        let normalizedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let preparedQuery = normalizedQuery.isEmpty ? nil : normalizedQuery

        debouncer.schedule { [weak self] in
            self?.interactor?.search(query: preparedQuery)
        }
    }

    func searchDidCancel() {
        debouncer.cancel()
        interactor?.search(query: nil)
    }

    func itemCreateDidTap() {
        router?.create()
    }

    func itemEditDidTap(_ item: ToDoListItem) {
        router?.update(id: item.id)
    }

    func itemDeleteDidTap(_ item: ToDoListItem) {
        interactor?.delete(id: item.id)
    }

    func itemSelectDidTap(_ item: ToDoListItem) {
        interactor?.toggle(id: item.id)
    }
}

// MARK: - ToDoListInteractorOutput

extension ToDoListPresenter: ToDoListInteractorOutput {
    func didUpdateItems(_ items: [ToDo]) {
        let items = items.map { model in
            ToDoListItem.mapFromDomain(model)
        }

        var snapshot = ToDoListSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)

        DispatchQueue.main.async {
            self.view?.setSnapshot(snapshot)
        }
    }
    
    func didFailToSyncItems(_ error: any Error) {
        DispatchQueue.main.async {
            self.view?.setLoadingError(error)
        }
    }
    
    func didFailToObserveItems(_ error: any Error) {
        DispatchQueue.main.async {
            self.view?.setLoadingError(error)
        }
    }

    func didFailToToggleItem(_ error: any Error) {
        // FIXME: Additional requirements required
    }

    func didFailToDeleteItem(_ error: any Error) {
        // FIXME: Additional requirements required
    }
}

private extension ToDoListPresenter {
    enum Constant {
        static let debouncerDelay = 0.25
    }
}
