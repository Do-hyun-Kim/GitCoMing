//
//  SearchViewSection.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import Differentiator

//MARK: Section Type
public enum SearchKeywordType: String, Equatable {
    case recentlyKeyword
}


//MARK: Section
public enum SearchSection {
    case search([SearchSectionItem])
    
    func getSectionType() -> SearchKeywordType {
        switch self {
        case .search: return .recentlyKeyword
        }
    }
}


//MARK: Item
public enum SearchSectionItem {
    case recentlyKeywordItem(SearchRecentlyKeywordCellReactor)
}



extension SearchSection: SectionModelType {
    
    public var items: [SearchSectionItem] {
        switch self {
        case let .search(items): return items
        }
    }
    
    public init(original: SearchSection, items: [SearchSectionItem]) {
        switch original {
        case .search: self = .search(items)
        }
    }
    
}
