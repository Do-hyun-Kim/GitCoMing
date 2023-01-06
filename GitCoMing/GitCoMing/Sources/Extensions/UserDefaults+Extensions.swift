//
//  UserDefaults+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import Foundation


public enum UserDefaultsKeys: String {
    case accessToken
    
}


public extension UserDefaults {
    
    
    func string(forKey: UserDefaultsKeys) -> String {
        return string(forKey: forKey.rawValue) ?? ""
    }
    
    
    func set(_ value: Any?, forKey: UserDefaultsKeys) {
        set(value, forKey: forKey)
    }
    
    func remove(forKey: UserDefaultsKeys) {
        return removeObject(forKey: forKey.rawValue)
    }
    
}
