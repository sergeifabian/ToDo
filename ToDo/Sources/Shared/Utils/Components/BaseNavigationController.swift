//
//  BaseNavigationController.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        setupNavigation()
        setupToolbar()
        setupView()
    }

    func setupNavigation() {
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = Theme.Color.accent
    }

    func setupToolbar() {
        toolbar.tintColor = Theme.Color.accent
    }

    func setupView() {
        setToolbarHidden(false, animated: false)
    }
}
