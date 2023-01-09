//
//  APIError.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import Foundation

import Alamofire

enum APIError: Error, Equatable {
    /// status code - 304 ⛔️
    case isNotModified
    
    /// status code - 422 ⛔️
    case isValidationEntityFailed
    
    /// status code - 503 ⛔️
    case ServiceUnavailable
    
    /// 데이터 포멧이 없음
    case dataNotAllowed
    
    case messageDescription(String)
    
}


extension Error {
    public var asGCMError: AFError? {
        return self as? AFError
    }
}
