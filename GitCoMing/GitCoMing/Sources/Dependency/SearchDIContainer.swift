//
//  SearchDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import Foundation


public final class SearchDIContainer: BaseDIContainer {
    
    //MARK: Property
    public typealias Reactor = SearchViewReactor
    public typealias Repository = SearchRepository
    public typealias ViewController = SearchViewController
    
    
    public func makeReactor() -> SearchViewReactor {
        return SearchViewReactor(searchRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return SearchViewRepo()
    }
    
    public func makeViewController() -> SearchViewController {
        return SearchViewController(reactor: makeReactor())
    }
    
}


public protocol SearchRepository {
    func responseSearchRecentlyKeyWordSectionItem() -> SearchSection
}


final class SearchViewRepo: SearchRepository {
    
    
    public init() {}
    
    func responseSearchRecentlyKeyWordSectionItem() -> SearchSection {
        var recentlyKeywordItems: [SearchSectionItem] = []
        var recentlyKeywordEntity = UserDefaults.standard.stringArray(forKey: .recentlyKeywords)
        for i in 0 ..< recentlyKeywordEntity.count {
            recentlyKeywordItems.append(.recentlyKeywordItem(SearchRecentlyKeywordCellReactor(keywordItems: recentlyKeywordEntity[i], indexPath: i)))
        }
        
        return SearchSection.search(recentlyKeywordItems)
    }
}
