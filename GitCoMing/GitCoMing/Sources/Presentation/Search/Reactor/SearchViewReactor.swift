//
//  SearchViewReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import Foundation

import ReactorKit
import RxSwift



public final class SearchViewReactor: Reactor {
    
    //MARK: Property
    public var initialState: State
    
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setLoading(Bool)
    }
    
    public struct State {
        var isLoading: Bool
    }
    
    
    init() {
        self.initialState = State(isLoading: false)
    }
    
    
    
    
    
}
