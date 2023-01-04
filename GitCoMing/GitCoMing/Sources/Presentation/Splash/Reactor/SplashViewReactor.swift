//
//  SplashViewReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import ReactorKit
import RxSwift
import RxCocoa


final class SplashViewReactor: Reactor {
    
    //MARK: Property
    var initialState: State
    
    
    enum Action {
        case didShowSplash
    }
    
    enum Mutaion {
        case setIsFinshSplash(Bool)
    }
    
    struct State {
        @Pulse var isSplash: Bool
    }
    
    init() {
        self.initialState = State(isSplash: false)
    }
    
    
    func mutate(action: Action) -> Observable<Mutaion> {
        
        switch action {
        case .didShowSplash:
            let willShowSplash = Observable<Mutaion>.just(.setIsFinshSplash(false))
            let willDisAppearSplash = Observable<Mutaion>.just(.setIsFinshSplash(true))
            
            return .concat(
                willShowSplash.delay(.seconds(1), scheduler: MainScheduler.instance),
                willDisAppearSplash
            )
        }
    }
    
    
    func reduce(state: State, mutation: Mutaion) -> State {
        var newState = state
        
        switch mutation {
        case let .setIsFinshSplash(isFinsh):
            newState.isSplash = isFinsh
        }
        
        return newState
    }
    
    
    
    
}



