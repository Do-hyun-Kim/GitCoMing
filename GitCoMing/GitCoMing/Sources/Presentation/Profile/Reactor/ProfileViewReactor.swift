//
//  ProfileViewReactor.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Foundation

import ReactorKit
import RxSwift


enum ProfileTransformType: GlobalEventType {
    public enum Event {
        case responseUserOrganizations
    }
    case none
}


public final class ProfileViewReactor: Reactor {
    
    //MARK: Property
    public var initialState: State
    private let profileRepository: ProfileRepository
    
    public enum Action {
        case viewDidLoad
    }
    
    public enum Mutation {
        case setUserProfileLoading(Bool)
        case updateProfile(Profile)
        case updateOrganizations([Organizations])
    }
    
    public struct State {
        var isUserProfileLoading: Bool
        var profileItem: Profile?
        @Pulse var organizationsItem: [Organizations]?
        @Pulse var profileSection: [ProfileSection]
    }
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
        self.initialState = State(
            isUserProfileLoading: false,
            profileSection: [
                .organizations([])
            ]
        )
    }
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromRequestOrganizationsMutation = ProfileTransformType.event.flatMap { [weak self] event in
            self?.requestUserOrganizations(from: event) ?? .empty()
        }
        return Observable.of(mutation, fromRequestOrganizationsMutation).merge()
    }
    
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let didUpdateProfile = Observable<Mutation>.just(.setUserProfileLoading(true))
            let willUpdateProfile = Observable<Mutation>.just(.setUserProfileLoading(false))
            
            return .concat(
                didUpdateProfile,
                profileRepository.responseMyProfile(),
                willUpdateProfile
            )
        }
    }
    
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setUserProfileLoading(isUserProfileLoading):
            newState.isUserProfileLoading = isUserProfileLoading
            
        case let .updateProfile(profileItem):
            newState.profileItem = profileItem
            
        case let .updateOrganizations(organizationsItem):
            let sectionIndex = self.getIndex(section: .organizations([]))
            newState.organizationsItem = organizationsItem
            newState.profileSection[sectionIndex] = profileRepository.responseOrganizationsSectionitem(item: organizationsItem)
            print("response Organizations: \(organizationsItem)")
        }
        
        return newState
        
    }
    
    
}


private extension ProfileViewReactor {
    
    private func requestUserOrganizations(from event: ProfileTransformType.Event) -> Observable<Mutation> {
        switch event {
        case .responseUserOrganizations:
            guard let userName = self.currentState.profileItem?.userName else { return .empty() }
            let requestOrganizations = profileRepository.responseOrganizations(userName)
            return requestOrganizations
        }
        
    }
    
    private func getIndex(section: ProfileSection) -> Int {
        var index: Int = 0
        
        for i in 0 ..< self.currentState.profileSection.count where self.currentState.profileSection[i].getSectionType() == section.getSectionType() {
            index = i
        }
        
        return index
    }
    
}
