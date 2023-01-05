//
//  SignInViewReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//
import Foundation

import ReactorKit
import RxSwift


public final class SignInViewReactor: Reactor {
    
    public enum Action {
        case didShowSignInView
    }
    
    public enum Mutation {
        case setLoading(Bool)
    }
    
    public struct State {
        @Pulse var isLoading: Bool = false
    }
    
    public var initialState: State
    private let signInRepository: SignInRepository
    
    init(signInRepository: SignInRepository) {
        self.initialState = State()
        self.signInRepository = signInRepository
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didShowSignInView:
            let willShowWebViewLoading = Observable<Mutation>.just(.setLoading(true))
            let didShowWebViewLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(
                willShowWebViewLoading,
                didShowWebViewLoading
            )
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
        }
        return newState
    }
    
    
}
