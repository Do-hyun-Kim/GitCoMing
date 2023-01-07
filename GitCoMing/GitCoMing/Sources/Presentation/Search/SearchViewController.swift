//
//  SearchViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import UIKit



public final class SearchViewController: BaseViewController<SearchViewReactor> {
    
    
    override init(reactor: SearchViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
}




