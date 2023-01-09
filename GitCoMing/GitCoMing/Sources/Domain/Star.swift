//
//  Star.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import Foundation



public struct Star: Codable {
    public var statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "Status"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode) ?? 500
    }
    
}
