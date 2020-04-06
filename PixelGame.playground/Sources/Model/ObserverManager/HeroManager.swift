//
//  HeroManager.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 02/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit

//MARK: HeroSubscriber
protocol HeroSubscriber: CustomStringConvertible {
    func positionUpdated(to position: CGPoint)
}

protocol HeroManagerProtocol: ObserverManager {
    var subscribers: [HeroSubscriber] { get set }
}

class HeroManager: HeroManagerProtocol {
    internal var subscribers: [HeroSubscriber] = []
    private var position: CGPoint = .zero {
        didSet {
            notifySubscribers()
        }
    }
    
    func add<T>(subscriber: T) {
        guard let subscriber = subscriber as? HeroSubscriber else { return }
        subscribers.append(subscriber)
        print("HeroManager: Subscriber added: \(subscriber)")
    }
    
    func remove<T>(subscriber filter: T) {
        guard let filter = filter as? (HeroSubscriber) -> Bool,
            let index = subscribers.firstIndex(where: filter) else { return }
        subscribers.remove(at: index)
    }
    
    func notifySubscribers() {
        subscribers.forEach({$0.positionUpdated(to: position)})
    }
}
