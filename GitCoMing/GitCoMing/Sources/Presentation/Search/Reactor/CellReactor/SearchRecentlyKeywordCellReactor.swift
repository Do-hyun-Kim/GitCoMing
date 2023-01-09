//
//  SearchRecentlyKeywordCellReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import Foundation

import ReactorKit
import RxSwift


public final class SearchRecentlyKeywordCellReactor: Reactor {
    
    //MARK: Property
    
    public var initialState: State
    
    public typealias Action = NoAction
    
    public struct State {
        var keywordItems: String
        var indexPath: Int
    }
    
    public init(keywordItems: String, indexPath: Int) {
        self.initialState = State(keywordItems: keywordItems, indexPath: indexPath)
    }

    
}
