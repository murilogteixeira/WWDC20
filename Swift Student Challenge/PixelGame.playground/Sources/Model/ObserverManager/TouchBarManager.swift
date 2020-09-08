//
//  TouchBarManager.swift
//  PixelGame
//
//  Created by Murilo Teixeira on 01/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

public protocol TouchBarSubscriber: CustomStringConvertible {
    var subscriberName: String { get set }
    func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton?)
}

extension TouchBarSubscriber {
    func buttonTapped(_ notificationType: TouchBarNotificationType, with button: NSButton? = nil) {}
}

protocol TouchBarManagerProtocol: ObserverManager {
    var subscribers: [TouchBarSubscriber] { get set }
}

public enum TouchBarNotificationType {
    case none, didBegin, didEnded, prevButton, nextButton, closeButton, confirmButton, numberButton, playButton
}

public class TouchBarManager: TouchBarManagerProtocol {
    internal var subscribers: [TouchBarSubscriber] = []
    
    private var notificationType: TouchBarNotificationType = .none
    private var buttonTapped: NSButton?
    
    public func add<T>(subscriber: T) {
        guard let subscriber = subscriber as? TouchBarSubscriber else { return }
        subscribers.append(subscriber)
//        print("TouchBarManager: Subscriber added: \(subscriber)")
    }
    
    func remove<T>(subscriber: T) {
        guard let filter = subscriber as? TouchBarSubscriber,
            let index = subscribers.firstIndex(where: {$0.subscriberName == filter.subscriberName}) else { return }
//        print("TouchBarManager: Subscriber removed: \(subscribers[index])")
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
