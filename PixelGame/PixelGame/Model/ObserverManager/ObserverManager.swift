//
//  ObserverManager.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 02/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import Foundation

protocol ObserverManager {
    func add<T>(subscriber: T)
    func remove<T>(subscriber filter: T)
    func notifySubscribers()
}

extension ObserverManager {
    internal func notifySubscribers() {}
}
