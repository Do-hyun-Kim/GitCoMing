//
//  ReactorKit+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import WeakMapTable
import RxSwift


private var streams: [String: Any] = [:]

public protocol GlobalEventType: Codable {
    associatedtype Event
}

public extension GlobalEventType {
    static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}

public protocol ModelNoneCodableType {
    associatedtype Event
}
public extension ModelNoneCodableType {
    static var event: PublishSubject<Event> {
        let key = String(describing: self)
        if let stream = streams[key] as? PublishSubject<Event> {
            return stream
        }
        let stream = PublishSubject<Event>()
        streams[key] = stream
        return stream
    }
}
