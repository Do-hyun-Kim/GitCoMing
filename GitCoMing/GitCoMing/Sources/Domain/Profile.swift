//
//  Profile.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Foundation


public struct Profile: Codable {
    public var userName: String
    public var userProfileUrl: String
    public var userOriginalName: String
    public var userFollowers: Int
    public var userFollowing: Int
    
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case userProfileUrl = "avatar_url"
        case userOriginalName = "name"
        case userFollowers = "followers"
        case userFollowing = "following"
    }
    
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.userProfileUrl = try container.decodeIfPresent(String.self, forKey: .userProfileUrl) ?? ""
        self.userOriginalName = try container.decodeIfPresent(String.self, forKey: .userOriginalName) ?? ""
        self.userFollowers = try container.decodeIfPresent(Int.self, forKey: .userFollowers) ?? 0
        self.userFollowing = try container.decodeIfPresent(Int.self, forKey: .userFollowing) ?? 0
    }
    
    
    func transformUserProfileURL() -> URL? {
        guard let profileUrl = URL(string: self.userProfileUrl) else { return nil }
        return profileUrl
    }
    
    
    
}
