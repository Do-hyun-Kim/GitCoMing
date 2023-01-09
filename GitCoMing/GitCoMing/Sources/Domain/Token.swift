//
//  Token.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/06.
//

import Foundation


public struct Token: Codable {
    public var accessToken: String
    public var tokenType: String
    public var scope: String
    
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken) ?? ""
        self.tokenType = try container.decodeIfPresent(String.self, forKey: .tokenType) ?? ""
        self.scope = try container.decodeIfPresent(String.self, forKey: .scope) ?? ""
    }
}
