//
//  UICollectionViewCell+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import UIKit

import ReactorKit
import RxSwift


open class BaseCollectionViewCell<T: ReactorKit.Reactor>: UICollectionViewCell, ReactorKit.View, BaseConfigure {
    
    //MARK: Property
    public var disposeBag: DisposeBag = DisposeBag()
    public typealias Reactor = T
    
    func configure() {}
    
    public func bind(reactor: T) {}
    
    
}
