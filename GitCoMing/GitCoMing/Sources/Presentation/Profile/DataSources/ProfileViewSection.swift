//
//  ProfileViewSection.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Differentiator


//MARK: Section Type
public enum ProfileSectionType: String, Equatable {
    case organizationsRepository
}

//MARK: Section
public enum ProfileSection {
    case organizations([ProfileSectionItem])
    
    func getSectionType() -> ProfileSectionType {
        switch self {
        case .organizations: return .organizationsRepository
        }
    }
    
}

//MARK: Item
public enum ProfileSectionItem {
    case organizationsItem(ProfileOrganizationsCellReactor)
    
}


extension ProfileSection: SectionModelType {
    
    public var items: [ProfileSectionItem] {
        switch self {
        case let .organizations(items): return items
        }
    }
    
    public init(original: ProfileSection, items: [ProfileSectionItem]) {
        switch original {
        case .organizations: self = .organizations(items)
        }
    }
}
