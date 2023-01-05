//
//  CommonWebDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation



public final class CommonWebDIContainer: BaseDIContainer {
    
    //MARK: Property
    public typealias Reactor = CommonWebViewReactor
    public typealias Repository = CommonWebRepository
    public typealias ViewController = CommonWebViewController
    
    public let webLoadURL: URL
    
    init(webLoadURL: URL) {
        self.webLoadURL = webLoadURL
    }
    
    public func makeReactor() -> CommonWebViewReactor {
        return CommonWebViewReactor(gitURL: self.webLoadURL)
    }
    
    public func makeRepository() -> Repository {
        return CommonWebViewRepo()
    }
    
    public func makeViewController() -> CommonWebViewController {
        return CommonWebViewController(reactor: makeReactor())
    }
    
}


public protocol CommonWebRepository {
    
}

final class CommonWebViewRepo: CommonWebRepository {
    
    init() {}
    
}
