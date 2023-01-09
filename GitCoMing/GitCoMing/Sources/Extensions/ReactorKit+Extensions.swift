//
//  ReactorKit+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//
import UIKit

import WeakMapTable
import RxSwift
import RxCocoa

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



public extension Reactive where Base: UISearchBar {
    
    var searchButtonTap: ControlEvent<String> {
        let keywordText: Observable<String> = self.base.searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(self.base.searchTextField.rx.text.asObservable())
            .flatMap { keyword -> Observable<String> in
                if let keywordEvent = keyword, !keywordEvent.isEmpty {
                    return .just(keywordEvent)
                } else {
                    return .empty()
                }
            }.do(onNext: { [weak base = self.base] _ in
                base?.searchTextField.text = nil
            })
        return ControlEvent(events: keywordText)
    }
}
