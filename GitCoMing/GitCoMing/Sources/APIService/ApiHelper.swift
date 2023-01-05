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
    func requestToString(endPoint: NetWorkEndPoint) -> Observable<String>
    
}



public final class APiManager: APiHelper {
    
    public static let shared: APiManager = APiManager()
    
    public func requestToString(endPoint: NetWorkEndPoint) -> Observable<String> {
        return Observable.create { observer in
        AF.request(endPoint)
                .responseString { response in
                    switch response.result {
                    case let .success(data):
                        observer.onNext(data)
                        observer.onCompleted()
                        return
                    case let .failure(error):
                        observer.onError(error)
                        return
                    }
                    
                }
            return Disposables.create()
        }
    }
    
    
}
