//
//  Bundle+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation


public extension Bundle {
    
    static func infoPlistValue(forKey key: String) -> Any? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else { return nil }
        return value
    }
    
}
