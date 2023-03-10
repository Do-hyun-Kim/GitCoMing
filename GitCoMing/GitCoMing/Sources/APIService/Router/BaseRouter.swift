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
    case signIn
    case myProfile
    case myOrganizations(String)
    case userProfile(String)
    case searchRepo(String?, String?)
    case activeStar(String, String)
    case activeUnStar(String, String)
}

//MARK: EndPoint Initialization
public struct NetWorkCofigure {
    //MARK: Property
    public let networkAPi: NetWorkAPi
    
    static var clientId: String {
        guard let infoClientId = Bundle.infoPlistValue(forKey: "GCMClientId") as? String else { return "" }
        return infoClientId
    }
    
    static var clientSecrets: String {
        guard let infoClientSecrets = Bundle.infoPlistValue(forKey: "GCMClientSecrets") as? String else { return "" }
        return infoClientSecrets
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
    var headers: HTTPHeaders { get }
    var parameter: Parameters { get }
    var encoding: ParameterEncoding { get }
}

extension NetWorkCofigure: URLRequestConvertible {
    
    
    var baseURL: String {
        switch networkAPi {
        case .signIn:
            return "https://github.com"
        case .signInCode:
            return "https://github.com"
        case .activeStar:
            return "https://github.com"
        default:
            return "https://api.github.com"
        }
    }
    
    var path: String {
        switch networkAPi {
        case .searchRepo:
            return "/search/repositories"
        case .signIn:
            return "/login/oauth/access_token"
        case .signInCode:
            return "/login/oauth/authorize"
        case let .activeStar(owner, repo):
            return "/user/starred/\(owner)/\(repo)"
        case let .activeUnStar(owner, repo):
            return "/user/starred/\(owner)/\(repo)"
        case .myProfile:
            return "/user"
        case let .myOrganizations(userName):
            return "/users/\(userName)/orgs"
        case let .userProfile(userName):
            return "/users/\(userName)"
        }
    }
    
    var method: HTTPMethod {
        switch networkAPi {
        case .signIn:
            return .post
        case .activeStar:
            return .put
        case .activeUnStar:
            return .delete
        default:
            return .get
        }
    }
    
    var headers: HTTPHeaders {
        switch networkAPi {
        case .signIn:
            return [
                "Accept":"application/json",
            ]
        case .signInCode:
            return [
                "Accept":"application/json",
            ]
        case .activeStar:
            return [
                "accept": "application/vnd.github+json",
                "Content-Length": "0",
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: .accessToken))"
            ]
        default:
            return [
                "accept": "application/vnd.github+json",
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: .accessToken))"
            ]
        }
    }
    
    var parameter: Parameters {
        switch networkAPi {
        case let .searchRepo(keyword, pages):
            return [
                "q": keyword ?? "",
                "page": pages ?? "10"
            ]
        default:
            return [:]
        }
    }
    
    var encoding: ParameterEncoding {
        switch networkAPi {
        default:
            return URLEncoding.default
        }
    }
    
    
    public func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        let urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        return urlRequest
        
    }
    
}


