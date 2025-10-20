//
//  Theme.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

enum Theme {
    enum Font {
        static let caption = UIFont.preferredFont(forTextStyle: .caption1)
        static let titleInput = UIFont.preferredFont(forTextStyle: .extraLargeTitle)
        static let detailsInput = UIFont.preferredFont(forTextStyle: .body)
        static let headline = UIFont.preferredFont(forTextStyle: .headline)
        static let footnote = UIFont.preferredFont(forTextStyle: .footnote)
    }

    enum Color {
        static let background = UIColor.systemBackground
        static let accent = UIColor(red: 254 / 255, green: 215 / 255, blue: 2 / 255, alpha: 1)
        static let primaryText = UIColor.label
        static let secondaryText = UIColor.secondaryLabel
        static let placeholderText = UIColor.placeholderText
        static let stroke = UIColor.separator
    }
}
