//
//  TouchBarManager.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 01/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol TouchBarSubscriber: CustomStringConvertible {
    func didBegin()
    func didEnded()
    func prevButtonPressed()
    func nextButtonPressed()
    func closeButtonPressed()
}

extension TouchBarSubscriber {
    func didBegin() {}
    func didEnded() {}
    func prevButtonPressed() {}
    func nextButtonPressed() {}
    func closeButtonPressed() {}
}

protocol TouchBarManagerProtocol: ObserverManager {
    var subscribers: [TouchBarSubscriber] { get set }
}

enum TouchBarNotificationType {
    case none, didBegin, didEnded, prevButton, nextButton, closeButton
}

public class TouchBarManager: TouchBarManagerProtocol {
    
    internal var subscribers: [TouchBarSubscriber] = []
    
    private var notificationType: TouchBarNotificationType = .none {
        didSet {
            notifySubscribers()
        }
    }
    
    public func add<T>(subscriber: T) {
        guard let subscriber = subscriber as? TouchBarSubscriber else { return }
        subscribers.append(subscriber)
        print("TouchBarManager: Subscriber added: \(subscriber)")
    }
    
    public func remove<T>(subscriber filter: T) {
        guard let filter = filter as? (TouchBarSubscriber) -> Bool,
            let index = subscribers.firstIndex(where: filter) else { return }
        subscribers.remove(at: index)
    }
    
    public func notifySubscribers() {
        switch notificationType {
        case .didBegin:
            subscribers.forEach({$0.didBegin()})
        case .didEnded:
            subscribers.forEach({$0.didEnded()})
        case .prevButton:
            subscribers.forEach({$0.prevButtonPressed()})
        case .nextButton:
            subscribers.forEach({$0.nextButtonPressed()})
        case .closeButton:
            subscribers.forEach({$0.closeButtonPressed()})
        default:
            break
        }
    }
    
    func didBegin() {
        notificationType = .didBegin
    }
    
    func didEnded() {
        notificationType = .didEnded
    }
    
    func prevButton() {
        notificationType = .prevButton
    }
    
    func nextButton() {
        notificationType = .nextButton
    }
    
    func closeButton() {
        notificationType = .closeButton
    }
}
