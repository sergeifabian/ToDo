//
//  FirstLaunchService.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

protocol HasFirstLaunchService {
    var firstLaunchService: FirstLaunchService { get }
}

protocol FirstLaunchService {
    func checkIsFirstLaunch() -> Bool
}

final class FirstLaunchServiceImpl: FirstLaunchService {
    private let key = "com.sergeifabian.todo.firstLaunchPassed"
    private let queue = DispatchQueue(label: "com.sergeifabian.todo.firstLaunchPassed.queue", attributes: .concurrent)

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func checkIsFirstLaunch() -> Bool {
        queue.sync(flags: .barrier) {
            if userDefaults.bool(forKey: key) {
                return false
            } else {
                userDefaults.set(true, forKey: key)
                return true
            }
        }
    }
}
