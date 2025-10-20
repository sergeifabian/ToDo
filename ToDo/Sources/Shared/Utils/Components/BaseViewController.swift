//
//  BaseViewController.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    func setup() {
        view.backgroundColor = Theme.Color.background

        setupNavigation()
        setupToolbar()
        setupHierarchy()
        setupLayout()
        setupView()
    }

    func setupNavigation() {}

    func setupToolbar() {}

    func setupHierarchy() {}

    func setupLayout() {}

    func setupView() {}
}
