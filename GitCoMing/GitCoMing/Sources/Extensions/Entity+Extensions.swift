//
//  Entity+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation


public struct Base<T>: Decodable where T: Decodable {
    
    /// 응답 결과
    public let item: T?
    
    
    enum CodingKeys: String, CodingKey {
        case item
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.item = try container.decodeIfPresent(T.self, forKey: .item)
    }
}


public extension Base {
  init(item: T?) {
    self.item = item
  }
}
