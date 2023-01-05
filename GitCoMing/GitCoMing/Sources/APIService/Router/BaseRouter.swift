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
    case signInCode
}

//MARK: EndPoint Initialization
public struct NetWorkEndPoint {
    //MARK: Property
    public let networkAPi: NetWorkAPi
    
    static var clientId: String {
        guard let infoClientId = Bundle.infoPlistValue(forKey: "GCMClientId") as? String else { return "" }
        return infoClientId
    }
    
    static var redirectUrI: String {
        guard let infoRedirectUrI = Bundle.infoPlistValue(forKey: "GCMRedirectURI") as? String else { return "" }
        return infoRedirectUrI
    }
    
    static var scope: String {
        guard let infoScope = Bundle.infoPlistValue(forKey: "GCMScope") as? String else { return "" }
        return infoScope
    }
    
    static var uuid: String {
        
        return UUID().uuidString
    }
    
    
    public init(networkAPi: NetWorkAPi) {
        self.networkAPi = networkAPi
    }

}

protocol NetWorkConfigure: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameter: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension NetWorkEndPoint: URLRequestConvertible {
    
    
    var baseURL: String {
        return "https://github.com"
    }
    
    var path: String {
        switch networkAPi {
        case .signInCode:
            return "/login/oauth/authorize"
        }
    }
    
    var method: HTTPMethod {
        switch networkAPi {
        case .signInCode:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch networkAPi {
        case .signInCode:
            return nil
        }
    }
    
    var parameter: Parameters? {
        switch networkAPi {
        case .signInCode:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch networkAPi {
        case .signInCode:
            return URLEncoding.queryString
        }
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        let urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        return urlRequest
        
    }
    
}


