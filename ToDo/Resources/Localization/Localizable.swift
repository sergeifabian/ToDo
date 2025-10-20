//
//  Localizable.swift
//  ToDo
//
//  Created by Sergei Fabian on 18.10.2025.
//

import Foundation

enum L10n {
    enum Builder {
        enum Form {
            enum Title {
                static let placeholder = String(localized: "builder.form.title.placeholder")
            }

            enum Details {
                static let placeholder = String(localized: "builder.form.details.placeholder")
            }
        }
    }

    enum List {
        enum Navigation {
            static let title = String(localized: "list.navigation.title")
        }

        enum Search {
            static let placeholder = String(localized: "list.search.placeholder")
        }

        enum Cell {
            enum Menu {
                static let edit = String(localized: "list.cell.edit")
                static let delete = String(localized: "list.cell.delete")
            }
        }

        enum Status {
            static let loading = String(localized: "list.status.loading")
            static let tasks: (Int) -> String = { String(localized: "\($0) list.status.tasks") }
        }
    }
}
