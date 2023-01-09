//
//  ProfileDIContainer.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Foundation

import RxSwift
import ReactorKit


public final class ProfileDIContainer: BaseDIContainer {
    
    
    //MARK: Property
    public typealias Reactor = ProfileViewReactor
    public typealias Repository = ProfileRepository
    public typealias ViewController = ProfileViewController
    
    public func makeReactor() -> ProfileViewReactor {
        return ProfileViewReactor(profileRepository: makeRepository())
    }
    
    public func makeRepository() -> ProfileRepository {
        return ProfileViewRepo()
    }
    
    public func makeViewController() -> ViewController {
        return ProfileViewController(reactor: makeReactor())
    }
    
}


public protocol ProfileRepository {
    func responseMyProfile() -> Observable<ProfileViewReactor.Mutation>
    func responseAnonymousProfile(_ userName: String) -> Observable<ProfileViewReactor.Mutation>
    func responseOrganizations(_ userName: String) -> Observable<ProfileViewReactor.Mutation>
    func responseOrganizationsSectionitem(item: [Organizations]) -> ProfileSection
}


final class ProfileViewRepo: ProfileRepository {
    
    //MARK: Property
    private let profileApiService: APiHelper
    
    public init(profileApiService: APiHelper = APiManager.shared) {
        self.profileApiService = profileApiService
    }
    
    func responseMyProfile() -> Observable<ProfileViewReactor.Mutation> {
        let createMyProfile = profileApiService.requestToNonKeyBound(endPoint: .init(networkAPi: .myProfile)).flatMap { (data: Profile) -> Observable<ProfileViewReactor.Mutation> in
            
            return .just(.updateProfile(data))
        }
        
        return createMyProfile
    }
    
    
    func responseAnonymousProfile(_ userName: String) -> Observable<ProfileViewReactor.Mutation> {
        
        let createAnonymousProfile = profileApiService.requestToNonKeyBound(endPoint: .init(networkAPi: .userProfile(userName))).flatMap { (data: Profile) -> Observable<ProfileViewReactor.Mutation> in
            
            return .just(.updateProfile(data))
        }
        
        return createAnonymousProfile
    }
    
    
    func responseOrganizations(_ userName: String) -> Observable<ProfileViewReactor.Mutation> {
        
        let createOrganizations = profileApiService.requestToNonKeyBound(endPoint: .init(networkAPi: .myOrganizations(userName))).flatMap { (data: [Organizations]) -> Observable<ProfileViewReactor.Mutation> in
            
            return .just(.updateOrganizations(data))
        }
        
        return createOrganizations
    }
    
    func responseOrganizationsSectionitem(item: [Organizations]) -> ProfileSection {
        
        var organiziationsSectionItem: [ProfileSectionItem] = []
        
        for i in 0 ..< item.count {
            organiziationsSectionItem.append(.organizationsItem(ProfileOrganizationsCellReactor(organizationsItem: item[i])))
        }
        
        return ProfileSection.organizations(organiziationsSectionItem)
        
    }
    
    
}
