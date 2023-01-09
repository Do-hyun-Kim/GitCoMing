//
//  UIFont+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/04.
//

import UIKit


public extension UIFont {
    
    static func regular(size: CGFloat) -> Self {
      return .init(name: "AppleSDGothicNeo-Regular", size: size)!
    }
    
    static func bold(size: CGFloat) -> Self {
      return .init(name: "AppleSDGothicNeo-Bold", size: size)!
    }
    
    static func semiBold(size: CGFloat) -> Self {
        return .init(name: "AppleSDGothicNeo-Semibold", size: size)!
    }
    
}
