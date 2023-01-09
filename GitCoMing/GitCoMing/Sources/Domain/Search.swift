//
//  Search.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import Foundation


public struct Search: Codable {
    public var repositoryName: String
    public var repositoryFullName: String
    public var repositoryDescription: String
    public var repositoryStarCount: Int
    public var repositoryOwner: SearchOwner
    
    enum CodingKeys: String, CodingKey {
        case repositoryName = "name"
        case repositoryFullName = "full_name"
        case repositoryDescription = "description"
        case repositoryStarCount = "stargazers_count"
        case repositoryOwner = "owner"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.repositoryName = try container.decodeIfPresent(String.self, forKey: .repositoryName) ?? ""
        self.repositoryFullName = try container.decodeIfPresent(String.self, forKey: .repositoryFullName) ?? ""
        self.repositoryDescription = try container.decodeIfPresent(String.self, forKey: .repositoryDescription) ?? ""
        self.repositoryStarCount = try container.decodeIfPresent(Int.self, forKey: .repositoryStarCount) ?? 0
        self.repositoryOwner = try container.decode(SearchOwner.self, forKey: .repositoryOwner)
        
    }
    
    
}



public struct SearchOwner: Codable {
    public var ownerName: String
    
    
    enum CodingKeys: String, CodingKey {
        case ownerName = "login"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.ownerName = try container.decodeIfPresent(String.self, forKey: .ownerName) ?? ""
    }
    
    
}
