//
//  ToDoListTableViewCell.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

final class ToDoListTableViewCell: BaseTableViewCell {

    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var detailsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Theme.Color.secondaryText
        label.font = Theme.Font.caption
        return label
    }()

    private lazy var indicatorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var bodyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailsLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.spacing = 6
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [indicatorImageView, bodyStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()

    // MARK: - Config

    override func setupHierarchy() {
        contentView.addSubview(contentStackView)
    }

    override func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            indicatorImageView.widthAnchor.constraint(equalToConstant: 24),
            indicatorImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    func fill(item: ToDoListItem) {
        fillTitle(item.title, completed: item.completed)
        fillDetails(item.details, completed: item.completed)
        fillDate(item.date)
        fillIndicator(completed: item.completed)
    }
}

// MARK: - Utils

private extension ToDoListTableViewCell {
    func fillTitle(_ title: String?, completed: Bool) {
        fillLabel(titleLabel, with: createTitle(title, completed: completed))
    }

    func fillDetails(_ details: String?, completed: Bool) {
        fillLabel(detailsLabel, with: createDescription(details, completed: completed))
    }

    func fillLabel(_ label: UILabel, with attributedText: NSAttributedString?) {
        label.attributedText = attributedText
        label.isHidden = attributedText.orEmpty.isEmpty
    }

    func fillDate(_ date: String) {
        dateLabel.text = date
    }

    func fillIndicator(completed: Bool) {
        if completed {
            indicatorImageView.image = .Symbol.checkmarkCircle
            indicatorImageView.tintColor = Theme.Color.accent
        } else {
            indicatorImageView.image = .Symbol.circle
            indicatorImageView.tintColor = Theme.Color.stroke
        }
    }

    func createTitle(_ string: String?, completed: Bool) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: Theme.Font.headline
        ]

        if completed {
            attributes.updateValue(NSUnderlineStyle.single.rawValue, forKey: .strikethroughStyle)
            attributes.updateValue(Theme.Color.secondaryText, forKey: .foregroundColor)
        } else {
            attributes.updateValue(Theme.Color.primaryText, forKey: .foregroundColor)
        }

        return NSAttributedString(string: string.orEmpty, attributes: attributes)
    }

    func createDescription(_ string: String?, completed: Bool) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: Theme.Font.caption
        ]

        if completed {
            attributes.updateValue(Theme.Color.secondaryText, forKey: .foregroundColor)
        } else {
            attributes.updateValue(Theme.Color.primaryText, forKey: .foregroundColor)
        }

        return NSAttributedString(string: string.orEmpty, attributes: attributes)
    }
}
