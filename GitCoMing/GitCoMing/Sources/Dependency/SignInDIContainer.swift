//
//  SignInDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation

import RxSwift
import ReactorKit

public final class SignInDIContainer: BaseDIContainer {
    
    //MARK: Property
    public typealias Reactor = SignInViewReactor
    public typealias Repository = SignInRepository
    public typealias ViewController = SignInViewController
    
    
    
    public func makeReactor() -> SignInViewReactor {
        return SignInViewReactor(signInRepository: makeRepository())
    }
    
    public func makeRepository() -> SignInRepository {
        return SignInViewRepo()
    }
    
    public func makeViewController() -> SignInViewController {
        return SignInViewController(reactor: makeReactor())
    }
    
}


public protocol SignInRepository {
    
}



final class SignInViewRepo: SignInRepository {
    
        
    
}
