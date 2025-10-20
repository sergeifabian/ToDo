//
//  Debouncer.swift
//  ToDo
//
//  Created by Sergei Fabian on 20.10.2025.
//

import Foundation

final class Debouncer {
    private let delay: TimeInterval
    private let queue: DispatchQueue

    private var workItem: DispatchWorkItem?

    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    func schedule(_ block: @escaping EmptyClosure) {
        workItem?.cancel()
        workItem = nil

        let item = DispatchWorkItem(block: block)
        workItem = item

        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }

    func cancel() {
        workItem?.cancel()
        workItem = nil
    }
}
