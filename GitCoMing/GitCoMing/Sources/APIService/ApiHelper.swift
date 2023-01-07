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
            ).responseData { response in
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
                        print(error.localizedDescription)
                    }
                case let .failure(error):
                    debugPrint(error.localizedDescription)
                    observer.onError(error)
                }
                
            }
            
            return Disposables.create()
        }
    }
    
}
