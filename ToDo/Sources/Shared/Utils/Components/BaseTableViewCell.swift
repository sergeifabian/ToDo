//
//  BaseTableViewCell.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        setupNavigation()
        setupHierarchy()
        setupLayout()
        setupView()
    }

    func setupNavigation() {}

    func setupHierarchy() {}

    func setupLayout() {}

    func setupView() {}
}
