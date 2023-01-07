//
//  SplashViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/04.
//

import UIKit
import SnapKit
import Then

import ReactorKit
import RxSwift
import RxCocoa

public protocol CoordinatorDelegate: AnyObject {
    func didShowLoginController()
}


final class SplashViewController: BaseViewController<SplashViewReactor> {
    
    //MARK: Property
    public weak var delegate: CoordinatorDelegate?
    
    
    private let mainLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "splashLogo")
        $0.contentMode = .scaleAspectFill
    }
    
    
    private let descriptionLabel = UILabel().then {
        $0.font = .bold(size: 24)
        $0.textColor = .gitDarkGray
        $0.text = "GitCoMing"
        $0.sizeToFit()
    }
    
    override init(reactor: SplashViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    //MARK: Configure
    override func configure() {
        
        _ = [mainLogoImageView, descriptionLabel].map {
            self.view.addSubview($0)
        }
        
        mainLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalTo(mainLogoImageView)
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(10)
        }
        
    }
    
    
    override func bind(reactor: SplashViewReactor) {
        
        Observable.just(())
            .map { Reactor.Action.didShowSplash }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        reactor.pulse(\.$isSplash)
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                vc.delegate?.didShowLoginController()
            }.disposed(by: disposeBag)
    }
    
}

