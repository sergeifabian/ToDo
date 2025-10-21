//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

protocol ToDoListView: AnyObject {
    func setIntialDataLoading()
    func setSnapshot(_ snapshot: ToDoListSnapshot)
    func setLoadingError(_ error: Error)
}

protocol ToDoListViewOutput: AnyObject {
    func viewDidLoad()
    func searchDidChange(query: String)
    func searchDidCancel()
    func itemCreateDidTap()
    func itemEditDidTap(_ item: ToDoListItem)
    func itemDeleteDidTap(_ item: ToDoListItem)
    func itemSelectDidTap(_ item: ToDoListItem)
}

final class ToDoListViewController: BaseViewController {

    var output: ToDoListViewOutput?

    // MARK: - Data

    private lazy var dataSource = ToDoListDataSource(tableView: tableView) { tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.className, for: indexPath)

        if let cell = cell as? ToDoListTableViewCell {
            cell.fill(item: item)
        }

        return cell
    }

    // MARK: - UI

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = L10n.List.Search.placeholder
        searchController.searchBar.tintColor = Theme.Color.accent
        searchController.searchBar.delegate = self
        return searchController
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: .zero, left: 20, bottom: .zero, right: 20)
        tableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: ToDoListTableViewCell.className)
        tableView.delegate = self
        return tableView
    }()

    private lazy var statusActivityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = Theme.Color.primaryText
        label.font = Theme.Font.footnote
        return label
    }()

    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [statusActivityIndicatorView, statusLabel])
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var statusBarButtonItem = UIBarButtonItem(
        customView: statusStackView
    )

    private lazy var buildBarButtonItem = UIBarButtonItem(
        image: .Symbol.squareAndPencil,
        style: .plain,
        target: self,
        action: #selector(buildBarButtonItemTapped)
    )

    // MARK: - Config

    override func setupNavigation() {
        navigationItem.searchController = searchController
    }

    override func setupToolbar() {
        toolbarItems = [
            .flexibleSpace(),
            statusBarButtonItem,
            .flexibleSpace(),
            buildBarButtonItem
        ]
    }

    override func setupHierarchy() {
        view.addSubview(tableView)
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    override func setupView() {
        title = L10n.List.Navigation.title
        definesPresentationContext = true
    }

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        output?.viewDidLoad()
    }

    // MARK: - Actions

    @objc private func buildBarButtonItemTapped(sender: UIBarButtonItem) {
        output?.itemCreateDidTap()
    }
}

// MARK: - ToDoListViewInput

extension ToDoListViewController: ToDoListView {
    func setIntialDataLoading() {
        statusActivityIndicatorView.startAnimating()
        statusLabel.text = L10n.List.Status.loading
    }

    func setSnapshot(_ snapshot: ToDoListSnapshot) {
        statusActivityIndicatorView.stopAnimating()
        statusLabel.text = L10n.List.Status.tasks(snapshot.numberOfItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func setLoadingError(_ error: any Error) {
        statusActivityIndicatorView.stopAnimating()
        statusLabel.text = error.localizedDescription
    }

    func setTogglingError(_ error: any Error) {
        // TODO: Additional requirements required
    }

    func setDeletingError(_ error: any Error) {
        // TODO: Additional requirements required
    }
}

// MARK: - UISearchResultsUpdating

extension ToDoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        output?.searchDidChange(query: searchController.searchBar.text.orEmpty)
    }
}

// MARK: - UISearchBarDelegate

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output?.searchDidCancel()
    }
}

// MARK: - UITableViewDelegate

extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let item = dataSource.itemIdentifier(for: indexPath) {
            output?.itemSelectDidTap(item)
        }
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return nil }

        let identifier = NSNumber(value: indexPath.row)

        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu() }

            return UIMenu(children: [
                self.createEditAction(for: item),
                self.createDeleteAction(for: item)
            ])
        }
    }

    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let row = configuration.identifier as? NSNumber,
              let cell = tableView.cellForRow(at: IndexPath(row: row.intValue, section: .zero)),
              let cell = cell as? ToDoListTableViewCell
        else { return nil }

        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(roundedRect: cell.contentView.bounds, cornerRadius: 12)

        return UITargetedPreview(view: cell.contentView, parameters: parameters)
    }
}

// MARK: - Menu

private extension ToDoListViewController {
    func createEditAction(for item: ToDoListItem) -> UIAction {
        UIAction(title: L10n.List.Cell.Menu.edit, image: .Symbol.squareAndPencil) { [weak self] _ in
            self?.output?.itemEditDidTap(item)
        }
    }

    func createDeleteAction(for item: ToDoListItem) -> UIAction {
        UIAction(title: L10n.List.Cell.Menu.delete, image: .Symbol.trash, attributes: .destructive) { [weak self] _ in
            self?.output?.itemDeleteDidTap(item)
        }
    }
}
