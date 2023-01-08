//
//  SearchDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import Foundation

import RxSwift
import RxCocoa
import ReactorKit


public final class PostDIContainer: BaseDIContainer {
    
    //MARK: Property
    public typealias Reactor = PostViewReactor
    public typealias Repository = PostRepository
    public typealias ViewController = PostViewController
    
    
    public func makeReactor() -> PostViewReactor {
        return PostViewReactor(postRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return PostViewRepo()
    }
    
    public func makeViewController() -> PostViewController {
        return PostViewController(reactor: makeReactor())
    }
    
    
}



public protocol PostRepository {
    func responseSearchRepository(_ keyword: String) -> Observable<PostViewReactor.Mutation>
    
}


final class PostViewRepo: PostRepository {
    
    
    //MARK: Property
    private let searchApiService: APiHelper
    
    init(searchApiService: APiHelper = APiManager.shared) {
        self.searchApiService = searchApiService
    }
    
    
    func responseSearchRepository(_ keyword: String) -> Observable<PostViewReactor.Mutation> {
        
        let createSearchRepository = searchApiService.requestInBound(endPoint: .init(networkAPi: .searchRepo(keyword))).flatMap { (data: [Search]) -> Observable<PostViewReactor.Mutation> in
            print("test Repository ")
            return .just(.requestSearchRepository(data))
        }
        
        return createSearchRepository
    }
    
}
