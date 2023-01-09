//
//  String+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import Foundation


public extension String {
    
    func localizableFormat() -> Self {
        let currentLanguage = Locale.current.languageCode
        
        let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj")
        guard let localizeBundle = Bundle(path: path ?? self) else { return self }
        
        return NSLocalizedString(self, bundle: localizeBundle, value: "", comment: "")
    }
    
    func localized(with argument: CVarArg = [], comment: String = "") -> Self {
        return String(format: self.localizableFormat(), argument)
    }
    
    
}

