//
//  BaseDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation


public protocol BaseDIContainer {
    
    associatedtype Reactor
    associatedtype Repository
    associatedtype ViewController
    
    func makeReactor() -> Reactor
    func makeRepository() -> Repository
    func makeViewController() -> ViewController
    
}
