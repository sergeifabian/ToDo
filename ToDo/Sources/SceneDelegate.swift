//
//  SceneDelegate.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private lazy var dependencies = DependenciesContainer()
    private lazy var factories = FactoriesContainer(dependencies: dependencies)

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        if let windowScene = scene as? UIWindowScene {
            window = UIWindow(windowScene: windowScene)
            window?.rootViewController = factories.makeListModule()
            window?.makeKeyAndVisible()
        }
    }
}
