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
    func responseSearchRepository(_ keyword: String, pages: String) -> Observable<PostViewReactor.Mutation>
    func responsePostRepositorySectionitem(item: [Search]) -> PostSection
    func requestActiveToRepositoryStar(owner: String, repository: String) -> Observable<PostRepositoryCellReactor.Mutation>
}


final class PostViewRepo: PostRepository {
    
    
    //MARK: Property
    private let postApiService: APiHelper
    
    init(postApiService: APiHelper = APiManager.shared) {
        self.postApiService = postApiService
    }
    
    
    func responseSearchRepository(_ keyword: String, pages: String) -> Observable<PostViewReactor.Mutation> {
        
        let createSearchRepository = postApiService.requestInBound(endPoint: .init(networkAPi: .searchRepo(keyword, pages))).flatMap { (data: [Search]) -> Observable<PostViewReactor.Mutation> in
            return .just(.requestSearchRepository(data))
        }
        
        return createSearchRepository
    }
    
    
    func responsePostRepositorySectionitem(item: [Search]) -> PostSection {
        var repositorySectionItem: [PostSectionItem] = []
        
        for i in 0 ..< item.count {
            repositorySectionItem.append(.repositoryItem(PostRepositoryCellReactor(repositoryItems: item[i], postCellRepository: self, indexPath: i)))
        }
        
        return PostSection.repositoryPost(repositorySectionItem)
    }
    
    func requestActiveToRepositoryStar(owner: String, repository: String) -> Observable<PostRepositoryCellReactor.Mutation> {
        let createActiveStar = postApiService.requestToNonKeyBound(endPoint: .init(networkAPi: .activeStar(owner, repository))).flatMap { (data: Star) -> Observable<PostRepositoryCellReactor.Mutation> in
            return .just(.updateAcitveToStar(data))
        }
        
        return createActiveStar
    }
}
