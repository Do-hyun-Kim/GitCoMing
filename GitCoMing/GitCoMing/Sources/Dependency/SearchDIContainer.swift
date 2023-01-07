//
//  SearchDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import Foundation




public final class SearchDIContainer: BaseDIContainer {
    
    //MARK: Property
    public typealias Reactor = SearchViewReactor
    public typealias Repository = SearchRepository
    public typealias ViewController = SearchViewController
    
    
    public func makeReactor() -> SearchViewReactor {
        return SearchViewReactor()
    }
    
    public func makeRepository() -> Repository {
        return SearchViewRepo()
    }
    
    public func makeViewController() -> SearchViewController {
        return SearchViewController(reactor: makeReactor())
    }
    
    
}



public protocol SearchRepository {
    
    
}


final class SearchViewRepo: SearchRepository {
    
    
}
