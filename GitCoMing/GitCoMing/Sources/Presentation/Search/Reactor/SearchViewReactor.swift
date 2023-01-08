//
//  SearchViewReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import Foundation

import ReactorKit
import RxSwift


enum SearchKeywordTransformType: GlobalEventType {
    public enum Event {
        case refreshKeyWordSection
        case didTapRecentlyKeyword(keyword: String)
    }
    case none
}


public final class SearchViewReactor: Reactor {
    
    //MARK: Property
    public var initialState: State
    private let searchRepository: SearchRepository
    
    public enum Action {
        case viewDidLoad
        case updateKeyword(String?)
    }
    
    
    public enum Mutation {
        case setLoading(Bool)
        case updateKeyword(String?)
        case updateKeywordItems
    }
    
    public struct State {
        var keyword: String?
        var isSearchLoading: Bool
        @Pulse var keywordSection: [SearchSection]
    }
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
        self.initialState = State(
            isSearchLoading: false,
            keywordSection: [
                self.searchRepository.responseSearchRecentlyKeyWordSectionItem()
            ]
        )
    }
    
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromRefreshSectionMutation = SearchKeywordTransformType.event.flatMap { [weak self] event in
            self?.updateRecentlyKeyword(from: event) ?? .empty()
        }
        return fromRefreshSectionMutation
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
        case let .updateKeyword(keyword):
            guard let searchKeyword = keyword,
                  searchKeyword.count > 1 else {
                return .concat(
                    .just(.updateKeyword(nil)),
                    .just(.updateKeywordItems)
                )
            }
            return .empty()
        }
    }
    

    public func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .setLoading(isSearchLoading):
            newState.isSearchLoading = isSearchLoading
            
        case let .updateKeyword(keyword):
            newState.keyword = keyword
        
        case .updateKeywordItems:
            let sectionIndex = self.getIndex(section: .search([]))
            newState.keywordSection[sectionIndex] = searchRepository.responseSearchRecentlyKeyWordSectionItem()
        }
        
        return newState
    }
    
}



private extension SearchViewReactor {
    
    private func getIndex(section: SearchSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.keywordSection.count where self.currentState.keywordSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
}


//MARK: SearchViewReactor Global Evnet ✈️ ➡️ Mutation

private extension SearchViewReactor {
    
    func updateRecentlyKeyword(from event: SearchKeywordTransformType.Event) -> Observable<Mutation> {
        switch event {
        case let .didTapRecentlyKeyword(keyword):
            
            return .just(.updateKeyword(keyword))
            
        case .refreshKeyWordSection:
            let didStartUpdateLoading = Observable<Mutation>.just(.setLoading(true))
            let updateSection = Observable<Mutation>.just(.updateKeywordItems)
            let willEndUpdateLoading = Observable<Mutation>.just(.setLoading(false))
            
            return .concat(
                didStartUpdateLoading,
                updateSection,
                willEndUpdateLoading
            )
        }
    }
    
}

