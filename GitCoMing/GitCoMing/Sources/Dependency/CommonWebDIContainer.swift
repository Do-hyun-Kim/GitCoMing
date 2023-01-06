//
//  CommonWebDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation


import RxSwift
import RxCocoa
import ReactorKit


public final class CommonWebDIContainer: BaseDIContainer {
    
    //MARK: Property
    public typealias Reactor = CommonWebViewReactor
    public typealias Repository = CommonWebRepository
    public typealias ViewController = CommonWebViewController
    
    public let webLoadURL: URL
    
    public init(webLoadURL: URL) {
        self.webLoadURL = webLoadURL
    }
    
    deinit {
        debugPrint(#function)
    }
    
    public func makeReactor() -> CommonWebViewReactor {
        return CommonWebViewReactor(gitURL: self.webLoadURL, webRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return CommonWebViewRepo()
    }
    
    public func makeViewController() -> CommonWebViewController {
        return CommonWebViewController(reactor: makeReactor())
    }
    
}


public protocol CommonWebRepository {
    func responseGitAccessToken(parameter: [String: String]) -> Observable<CommonWebViewReactor.Mutation>
}

final class CommonWebViewRepo: CommonWebRepository {
    
    //MARK: Property
    private let webApiService: APiHelper
    
    
    public init(webApiService: APiHelper = APiManager.shared) {
        self.webApiService = webApiService
    }
    
    
    func responseGitAccessToken(parameter: [String: String]) -> Observable<CommonWebViewReactor.Mutation> {
        let createAccressToken = webApiService.requestToAccessToken(endPoint: .init(networkAPi: .signIn), parameter: parameter).flatMap { (data: Token) -> Observable<CommonWebViewReactor.Mutation> in
            
            return .just(.setAccessToken(data))
        }
        
        return createAccressToken
    }
    
    
    
}
