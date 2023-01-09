//
//  PostViewSection.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Differentiator


//MARK: Section Type
public enum PostSectionType: String, Equatable {
    case repositoryItem
}

//MARK: Section
public enum PostSection {
    case repositoryPost([PostSectionItem])
    
    func getSectionType() -> PostSectionType {
        switch self {
        case .repositoryPost: return .repositoryItem
        }
    }
}

//MARK: Item
public enum PostSectionItem {
    case repositoryItem(PostRepositoryCellReactor)
}


extension PostSection: SectionModelType {
    
    public var items: [PostSectionItem] {
        switch self {
        case let .repositoryPost(items): return items
        }
    }
    
    public init(original: PostSection, items: [PostSectionItem]) {
        switch original {
        case .repositoryPost: self = .repositoryPost(items)
        }
    }
    
}


