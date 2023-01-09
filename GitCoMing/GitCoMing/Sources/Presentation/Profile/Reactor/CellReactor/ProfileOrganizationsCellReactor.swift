//
//  ProfileOrganizationsCellReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Foundation

import ReactorKit
import RxSwift


public final class ProfileOrganizationsCellReactor: Reactor {
    
    //MARK: Property
    public var initialState: State
    
    public typealias Action = NoAction
    
    public struct State {
        var organizationsItem: Organizations
    }
    
    public init(organizationsItem: Organizations) {
        self.initialState = State(organizationsItem: organizationsItem)
    }
}
