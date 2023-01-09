//
//  ApiHelper.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import Foundation

import Alamofire
import RxSwift

public protocol APiHelper {
    func requestOutBound<T>(endPoint: NetWorkCofigure, parameter: [String: String]) -> Observable<T> where T: Decodable
    func requestInBound<T>(endPoint: NetWorkCofigure) -> Observable<T> where T: Decodable
    func requestToNonKeyBound<T>(endPoint: NetWorkCofigure) -> Observable<T> where T: Decodable
}



public final class APiManager: APiHelper {
    
    public static let shared: APiManager = APiManager()
    
    
    public func requestOutBound<T>(endPoint: NetWorkCofigure, parameter: [String: String]) -> Observable<T>  where T: Decodable {
        
        let urlEndPoint = endPoint.baseURL + endPoint.path
        
        return Observable.create { observer in
            AF.request(
                urlEndPoint,
                method: endPoint.method,
                parameters: parameter,
                encoder: URLEncodedFormParameterEncoder.default,
                headers: endPoint.headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case let .success(data):
                    do {
                        let entity = try JSONDecoder().decode(T.self, from: data)
                        debugPrint("=========EVENT==========")
                        debugPrint("=======\(entity)==========")
                        observer.onNext(entity)
                        observer.onCompleted()
                        debugPrint("=========COMPLETE========")
                    } catch {
                        observer.onError(APIError.messageDescription(error.localizedDescription))
                    }
                case let .failure(error):
                    switch response.response?.statusCode {
                    case 304:
                        observer.onError(APIError.isNotModified)
                    case 422:
                        observer.onError(APIError.isValidationEntityFailed)
                    case 503:
                        observer.onError(APIError.ServiceUnavailable)
                    default:
                        observer.onError(APIError.messageDescription(error.localizedDescription))
                    }
                    debugPrint(error.localizedDescription)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    
    
    public func requestInBound<T>(endPoint: NetWorkCofigure) -> Observable<T> where T : Decodable {
        let urlEndPoint = endPoint.baseURL + endPoint.path
        
        guard let originUrl = urlEndPoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return .empty()
        }
        
        return Observable.create { observer in
            AF.request(
                originUrl,
                method: endPoint.method,
                parameters: endPoint.parameter,
                encoding: endPoint.encoding,
                headers: endPoint.headers
            )
                .responseData { response in
                    switch response.result {
                    case let .success(data):
                        print("return Success: inbound")
                        do {
                            let baseEntity = try JSONDecoder().decode(Base<T>.self, from: data)
                            if let entity = baseEntity.items {
                                observer.onNext(entity)
                                observer.onCompleted()
                            }
                            debugPrint("=========BASE EVENT==========")
                            debugPrint("=======\(baseEntity)==========")
                            debugPrint("=========COMPLETE========")
                        } catch {
                            print(error.localizedDescription)
                            observer.onError(APIError.messageDescription(error.localizedDescription))
                        }
                    case let .failure(error):
                        switch response.response?.statusCode {
                        case 304:
                            observer.onError(APIError.isNotModified)
                        case 422:
                            observer.onError(APIError.isValidationEntityFailed)
                        case 503:
                            observer.onError(APIError.ServiceUnavailable)
                        default:
                            observer.onError(APIError.messageDescription(error.localizedDescription))
                        }
                        debugPrint(error.localizedDescription)
                    }
                }
            
            
            return Disposables.create()
        }
    }
    
    
    public func requestToNonKeyBound<T>(endPoint: NetWorkCofigure) -> Observable<T> where T : Decodable {
        let urlEndPoint = endPoint.baseURL + endPoint.path
        
        return Observable.create { observer in
            AF.request(
                urlEndPoint,
                method: endPoint.method,
                encoding: endPoint.encoding,
                headers: endPoint.headers
            ).responseData { response in
                switch response.result {
                case let .success(data):
                    print("success : \(data)")
                    do {
                        let baseEntity = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(baseEntity)
                        observer.onCompleted()
                        debugPrint("=========BASE EVENT==========")
                        debugPrint("=======\(baseEntity)==========")
                        debugPrint("=========COMPLETE========")
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(APIError.messageDescription(error.localizedDescription))
                    }
                case let .failure(error):
                    switch response.response?.statusCode {
                    case 304:
                        observer.onError(APIError.isNotModified)
                    case 422:
                        observer.onError(APIError.isValidationEntityFailed)
                    case 503:
                        observer.onError(APIError.ServiceUnavailable)
                    default:
                        observer.onError(APIError.messageDescription(error.localizedDescription))
                    }
                    debugPrint(error.localizedDescription)
                }
            }
            return Disposables.create()
        }
    }
}

