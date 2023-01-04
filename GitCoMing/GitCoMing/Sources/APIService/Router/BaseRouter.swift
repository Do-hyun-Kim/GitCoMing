//
//  BaseRouter.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Alamofire
import RxSwift
import Foundation


//MARK: NetWork API
public enum NetWorkAPi {
    case signIn
}

//MARK: EndPoint Initialization
public struct NetWorkEndPoint {
    //MARK: Property
    public let networkAPi: NetWorkAPi
    
    public init(networkAPi: NetWorkAPi) {
        self.networkAPi = networkAPi
    }

}

protocol NetWorkConfigure: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameter: Parameters { get }
    var encoding: ParameterEncoding { get }
}

extension NetWorkEndPoint: URLRequestConvertible {
    
    
    var baseURL: String {
        return "https://github.com"
    }
    
    var path: String {
        switch networkAPi {
        case .signIn:
            return "/login/oauth/authorize"
        }
    }
    
    var method: HTTPMethod {
        switch networkAPi {
        case .signIn:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch networkAPi {
        case .signIn:
            return nil
        }
    }
    
    var parameter: Parameters {
        switch networkAPi {
        case .signIn:
            return ["client_id": "1a75c931ee47226210d9"]
        }
    }
    
    var encoding: ParameterEncoding {
        switch networkAPi {
        case .signIn:
            return JSONEncoding.default
        }
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        let urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        return urlRequest
        
    }
    
}


