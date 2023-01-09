//
//  PostRepositoryCellReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Foundation

import ReactorKit
import RxSwift


public final class PostRepositoryCellReactor: Reactor {
        
    //MARK: Property
    public var initialState: State
    private let postCellRepository: PostRepository
    
    public enum Action {
        case didTapStarButton
    }
    
    public enum Mutation {
        case updateAcitveToStar(Star)
    }
    
    public struct State {
        var repositoryItems: Search
        var indexPath: Int
        var repositoryStarItems: Star?
    }
    
    //TODO: indexPath 값 심어 넣기
    public init(repositoryItems: Search, postCellRepository: PostRepository, indexPath: Int) {
        self.postCellRepository = postCellRepository
        self.initialState = State(repositoryItems: repositoryItems, indexPath: indexPath)
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapStarButton:

            let updateToStar = postCellRepository.requestActiveToRepositoryStar(
                owner: self.currentState.repositoryItems.repositoryOwner.ownerName,
                repository: self.currentState.repositoryItems.repositoryName
            )
            
            return updateToStar
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .updateAcitveToStar(starItems):
            newState.repositoryStarItems = starItems
            print("active Star Data: \(newState.repositoryStarItems)")
        }
        return newState
    }
    
}
