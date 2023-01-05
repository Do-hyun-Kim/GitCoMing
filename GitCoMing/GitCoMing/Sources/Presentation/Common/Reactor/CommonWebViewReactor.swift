//
//  CommonWebViewReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//
import Foundation

import ReactorKit
import RxSwift


public final class CommonWebViewReactor: Reactor {
    
    
    public var initialState: State
    
    
    public typealias Action = NoAction
    
    public struct State {
        var isWebLoading: Bool
        var gitURL: URL
    }
    
    
    public init(gitURL: URL) {
        self.initialState = State(
            isWebLoading: false,
            gitURL: gitURL
        )
    }
    
    
}
