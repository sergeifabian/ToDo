//
//  ToDoBuilderView.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

protocol ToDoBuilderView: AnyObject {
    func setItem(_ item: ToDoListItem)
}

protocol ToDoBuilderViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillDisappear()
    func titleDidChange(_ title: String)
    func detailsDidChange(_ details: String)
}

final class ToDoBuilderViewController: BaseViewController {

    var output: ToDoBuilderViewOutput?

    // MARK: - UI

    private lazy var titleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = L10n.Builder.Form.Title.placeholder
        textField.tintColor = Theme.Color.accent
        textField.delegate = self
        textField.font = Theme.Font.titleInput
        return textField
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Color.secondaryText
        label.font = Theme.Font.caption
        return label
    }()

    private lazy var detailsTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.showsVerticalScrollIndicator = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        textView.textColor = Theme.Color.placeholderText
        textView.tintColor = Theme.Color.accent
        textView.delegate = self
        textView.font = Theme.Font.detailsInput
        textView.text = L10n.Builder.Form.Details.placeholder
        return textView
    }()

    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextField, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, detailsTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Config

    override func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
    }

    override func setupHierarchy() {
        view.addSubview(contentStackView)
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
        ])
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        output?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        output?.viewWillDisappear()
    }
}

// MARK: - ToDoBuilderView

extension ToDoBuilderViewController: ToDoBuilderView {
    func setItem(_ item: ToDoListItem) {
        titleTextField.text = item.title
        dateLabel.text = item.date

        if item.details.orEmpty.isNotEmpty {
            detailsTextView.textColor = Theme.Color.primaryText
            detailsTextView.text = item.details
        }
    }
}

// MARK: - UITextFieldDelegate

extension ToDoBuilderViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if let updatedText = changeText(textField.text, in: range, with: string) {
            output?.titleDidChange(updatedText)
        }

        return true
    }
}

// MARK: - UITextViewDelegate

extension ToDoBuilderViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let updatedText = changeText(textView.text, in: range, with: text) {
            output?.detailsDidChange(updatedText)
        }

        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == Theme.Color.placeholderText {
            textView.textColor = Theme.Color.primaryText
            textView.text = String()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.orEmpty.isEmpty {
            textView.textColor = Theme.Color.placeholderText
            textView.text = L10n.Builder.Form.Details.placeholder
        }
    }
}

// MARK: - Utils

private extension ToDoBuilderViewController {
    func changeText(_ text: String?, in range: NSRange, with string: String) -> String? {
        Range(range, in: text.orEmpty).flatMap { range in
            text.orEmpty.replacingCharacters(in: range, with: string)
        }
    }
}
