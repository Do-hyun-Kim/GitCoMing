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
    
    //MARK: Property
    public var initialState: State
    private let webRepository: CommonWebRepository

    public enum Action {
        case requestAccessToken(String)
    }
    
    public struct State {
        var isWebLoading: Bool
        var gitURL: URL
        @Pulse var gitAccessToken: Token?
    }
    
    public enum Mutation {
        case setWebLoading(Bool)
        case setAccessToken(Token)
    }
    
    
    public init(gitURL: URL, webRepository: CommonWebRepository) {
        self.webRepository = webRepository
        self.initialState = State(
            isWebLoading: false,
            gitURL: gitURL
        )
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case let .requestAccessToken(redirectCode):
            let accessTokenParameter: [String: String] = [
                "client_id": NetWorkCofigure.clientId,
                "client_secret": NetWorkCofigure.clientSecrets,
                "code": redirectCode            
            ]

            let startRequestLoading = Observable<Mutation>.just(.setWebLoading(true))
            let requestAccessToken = webRepository.responseGitAccessToken(parameter: accessTokenParameter)
            let endRequestLoading = Observable<Mutation>.just(.setWebLoading(false))
            
            return .concat(
                startRequestLoading,
                requestAccessToken,
                endRequestLoading
            )
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .setWebLoading(isWebLoading):
            newState.isWebLoading = isWebLoading
            
        case let .setAccessToken(token):
            newState.gitAccessToken = token
        }
        
        return newState
    }
    
    
}
