//
//  UIView+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import UIKit

import RxSwift


class BaseView: UIView {
    
    //MARK: Property
    lazy private(set) var className: String =  {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    deinit {
        print("Class : \(self.className)")
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}


