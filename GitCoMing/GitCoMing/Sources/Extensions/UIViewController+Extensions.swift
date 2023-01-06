//
//  UIViewController+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/04.
//

import UIKit
import Then

import ReactorKit


protocol BaseConfigure {
    func configure()
}


open class BaseViewController<T: ReactorKit.Reactor>: UIViewController, ReactorKit.View, BaseConfigure {
    
    //MARK: Property
    public var disposeBag: DisposeBag = DisposeBag()
    public typealias Reactor = T
    
    lazy var activityIndicatorView = UIActivityIndicatorView().then{
        if #available(iOS 13.0, *) {
            $0.style = .medium
        } else {
            // Fallback on earlier versions
            $0.style = .gray
        }
    }
    
    
    init(reactor: T? = nil) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    open func configure() {}
    
    
    public func bind(reactor: T) {}
}
