//
//  UserDefaults+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import Foundation


public enum UserDefaultsKeys: String {
    case accessToken
    case recentlyKeywords
    
}


public extension UserDefaults {
    
    
    func string(forKey: UserDefaultsKeys) -> String {
        return string(forKey: forKey.rawValue) ?? ""
    }
    
    func stringArray(forKey: UserDefaultsKeys) -> [String] {
        return stringArray(forKey: forKey.rawValue) ?? []
    }
    
    func setRecentlyKeyWord(keyword: String) {
        var saveData = UserDefaults.standard.stringArray(forKey: .recentlyKeywords)
        saveData = saveData.filter { $0 != keyword }
        saveData.insert(keyword, at: 0)
        saveData = Array<String>(saveData.prefix(Int(10)))
        
        UserDefaults.standard.set(saveData, forKey: .recentlyKeywords)
    }
    
    
    func set(_ value: Any?, forKey: UserDefaultsKeys) {
        set(value, forKey: forKey.rawValue)
    }
    
    func remove(forKey: UserDefaultsKeys) {
        return removeObject(forKey: forKey.rawValue)
    }
    
}
