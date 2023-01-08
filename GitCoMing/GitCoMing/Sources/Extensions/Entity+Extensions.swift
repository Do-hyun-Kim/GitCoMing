//
//  Entity+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation


public struct Base<T>: Decodable where T: Decodable {
    
    /// 응답 결과
    public let items: T?
    
    
    enum CodingKeys: String, CodingKey {
        case items
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decodeIfPresent(T.self, forKey: .items)
    }
}


public extension Base {
    init(items: T?) {
        self.items = items
    }
}
