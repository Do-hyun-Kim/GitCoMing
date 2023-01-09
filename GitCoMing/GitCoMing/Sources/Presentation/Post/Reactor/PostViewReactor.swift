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
        case updateSearchPage(Int, Bool)
    }
    
    public enum Mutation {
        case requestSearchRepository([Search])
        case setUpdatePages(Int)
        case setLoading(Bool)
        case setPagesLoading(Bool)
    }
    
    private var postSearchKeyword: String = ""
    
    public struct State {
        var isLoading: Bool
        var pages: Int
        @Pulse var isSearchPageLoading: Bool
        @Pulse var repositoryItem: [Search]?
        @Pulse var section: [PostSection]
    }
    
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
        self.initialState = State(
            isLoading: false,
            pages: 10,
            isSearchPageLoading: false,
            section: [
                .repositoryPost([])
            ]
        )
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
            self.postSearchKeyword = keyword
            return .concat(
                didStartKeywordUpdateLoading,
                postRepository.responseSearchRepository(keyword, pages: "10"),
                willEndKeywordUpdateLoading
            )
            
        case let .updateSearchPage(pages, isUpdatePage):
            let didUpdatePageLoading = Observable<Mutation>.just(.setPagesLoading(isUpdatePage))
            let willUpdatePoageLoading = Observable<Mutation>.just(.setPagesLoading(false))
            let updatePages = Observable<Mutation>.just(.setUpdatePages(pages))
            
            return .concat(
                didUpdatePageLoading,
                updatePages,
                postRepository.responseSearchRepository(postSearchKeyword, pages: String(pages)),
                willUpdatePoageLoading
            )
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        
        var newState = state
        
        switch mutation {
        case let .setLoading(isLoading):
            newState.isLoading = isLoading
            
        case let .requestSearchRepository(repositoryItem):
            let sectionIndex = self.getIndex(section: .repositoryPost([]))
            newState.repositoryItem = repositoryItem
            newState.section[sectionIndex] = postRepository.responsePostRepositorySectionitem(item: repositoryItem)
        case let .setUpdatePages(pages):
            newState.pages = self.currentState.pages + pages
            
        case let .setPagesLoading(isSearchPageLoading):
            newState.isSearchPageLoading = isSearchPageLoading
        }
        
        return newState
        
    }
    
    
}


private extension PostViewReactor {
    private func getIndex(section: PostSection) -> Int {
        var index: Int = 0
        for i in 0 ..< self.currentState.section.count where self.currentState.section[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
}


// MARK: PostViewReactor Global Event ✈️ ➡️ Action
private extension PostViewReactor {
    
    func updateSearchToPost(from event: PostTransformType.Event) -> Observable<Action> {
        switch event {
        case let .searchToKeyword(keyword):
            return .just(.updateSearchKeyword(keyword))
        }
    }
    
}
