//
//  Organizations.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Foundation


public struct Organizations: Codable {
    public var organizationsName: String
    public var organizationsUrl: String
    
    enum CodingKeys: String, CodingKey {
        case organizationsName = "login"
        case organizationsUrl = "avatar_url"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.organizationsName = try container.decodeIfPresent(String.self, forKey: .organizationsName) ?? ""
        self.organizationsUrl = try container.decodeIfPresent(String.self, forKey: .organizationsUrl) ?? ""
    }
    
    
    func transformOrganizationsURL() -> URL? {
        guard let organizationsUrl = URL(string: self.organizationsUrl) else { return nil }
        return organizationsUrl
    }
    
}
