//
//  SearchViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import UIKit
import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture
import ReactorKit


public final class PostViewController: BaseViewController<PostViewReactor> {

    
    //MARK: Property
    private let emptyDescriptionLogo = UIImageView().then {
        $0.image = UIImage(named: "emptyRepository")
        $0.contentMode = .scaleAspectFill
    }
    
    private let emptyDescriptionLabel = UILabel().then {
        $0.text = "검색한 레포지토리가 없습니다.".localized()
        $0.textColor = .gitGray
        $0.font = .regular(size: 18)
        $0.sizeToFit()
        $0.textAlignment = .center
    }
    
    private let searchView: SearchView = SearchView().then {
        $0.layer.borderColor = UIColor.gitLightGray?.cgColor
        $0.layer.borderWidth = 2
    }
    
    
    
    override init(reactor: PostViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.view.backgroundColor = .white
    }
    
    
    
    //MARK: Configure
    public override func configure() {
        
        _ = [searchView, emptyDescriptionLogo, emptyDescriptionLabel, activityIndicatorView].map {
            self.view.addSubview($0)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
        }
        
        emptyDescriptionLogo.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalTo(emptyDescriptionLogo)
            $0.top.equalTo(emptyDescriptionLogo.snp.bottom).offset(10)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    
    public override func bind(reactor: PostViewReactor) {
        
        Observable.just(())
            .map{ Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        searchView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                let searchViewController = SearchDIContainer().makeViewController()
                vc.navigationController?.pushViewController(searchViewController, animated: true)
            }.disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx
            .notification(.searchToPost)
            .withUnretained(self)
            .subscribe(onNext: { vc, userInfo in
                guard let searchKeyword = userInfo as? String else { return }
                PostTransformType.event.onNext(.searchToKeyword(keyword: searchKeyword))
            }).disposed(by: disposeBag)
        
        reactor.state
            .map{ $0.isLoading }
            .observe(on: MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    
    
}
