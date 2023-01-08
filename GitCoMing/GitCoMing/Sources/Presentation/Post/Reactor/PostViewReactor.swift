//
//  PostViewReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import Foundation

import ReactorKit
import RxSwift


public enum PostTransformType: GlobalEventType {
    public enum Event {
        case searchToKeyword(keyword: String)
    }
    case none
}


public final class PostViewReactor: Reactor {
    
    //MARK: Property
    public var initialState: State
    private let postRepository: PostRepository
    
    public enum Action {
        case viewDidLoad
        case updateSearchKeyword(String)
    }
    
    public enum Mutation {
        case requestSearchRepository([Search])
        case setLoading(Bool)
    }
    
    public struct State {
        var isLoading: Bool
        @Pulse var repositoryItem: [Search]?
    }
    
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
        self.initialState = State(isLoading: false)
    }
    
    
    public func transform(action: Observable<Action>) -> Observable<Action> {
        let fromUpdateToSearchAction = PostTransformType.event.flatMap { [weak self] event in
            self?.updateSearchToPost(from: event) ?? .empty()
        }
        
        return Observable.of(action, fromUpdateToSearchAction).merge()
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .viewDidLoad:
            let startLoading = Observable<Mutation>.just(.setLoading(true))
            let endLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(
                startLoading,
                endLoading
            )
        case let .updateSearchKeyword(keyword):
            let didStartKeywordUpdateLoading = Observable<Mutation>.just(.setLoading(true))
            let willEndKeywordUpdateLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(
                didStartKeywordUpdateLoading,
                postRepository.responseSearchRepository(keyword),
                willEndKeywordUpdateLoading
            )
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .requestSearchRepository(repositoryItem):
            newState.repositoryItem = repositoryItem
        }
        
        return newState
        
    }
    
    
}


// MARK: PostViewReactor Global Event ✈️ ➡️ Action
extension PostViewReactor {
    
    func updateSearchToPost(from event: PostTransformType.Event) -> Observable<Action> {
        switch event {
        case let .searchToKeyword(keyword):
            return .just(.updateSearchKeyword(keyword))
        }
    }
    
}
