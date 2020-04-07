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
    func confirmButtonPressed()
    func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton?)
}

extension TouchBarSubscriber {
    func didBegin() {}
    func didEnded() {}
    func prevButtonPressed() {}
    func nextButtonPressed() {}
    func closeButtonPressed() {}
    func confirmButtonPressed() {}
    func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {}
}

protocol TouchBarManagerProtocol: ObserverManager {
    var subscribers: [TouchBarSubscriber] { get set }
}

public enum TouchBarNotificationType {
    case none, didBegin, didEnded, prevButton, nextButton, closeButton, confirmButton, numberButton
}

public class TouchBarManager: TouchBarManagerProtocol {
    
    internal var subscribers: [TouchBarSubscriber] = []
    
    private var notificationType: TouchBarNotificationType = .none
    private var buttonTapped: NSButton?
    
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
        subscribers.forEach({$0.buttonTapped(notificationType, with: buttonTapped)})
    }
    
    public func notify(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {
        self.notificationType = notificationType
        self.buttonTapped = button
        notifySubscribers()
    }
    
}
