//
//  SignInViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import UIKit
import Then
import SnapKit

import ReactorKit
import RxSwift
import RxCocoa


public final class SignInViewController: BaseViewController<SignInViewReactor> {
    
    //MARK: Property
    private let signInLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "splashLogo")
        $0.contentMode = .scaleAspectFill
    }
    
    private let signInAppDescriptionLabel = UILabel().then {
        $0.font = .bold(size: 24)
        $0.textColor = .gitDarkGray
        $0.text = "GitCoMing"
        $0.sizeToFit()
    }
    
    
    private let signInButton = UIButton(type: .custom).then {
        $0.layer.cornerRadius = 5
        $0.setTitle("Sign in with GitHub", for: .normal)
        $0.setTitleColor(UIColor.gitWhite, for: .normal)
        $0.backgroundColor = UIColor.gitDarkGray
        $0.semanticContentAttribute = .forceLeftToRight
    }
    
    override init(reactor: SignInViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(#function)
    }
    
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    //MARK: Configure
    public override func configure() {
        self.view.backgroundColor = .gitWhite
        
        _ = [signInLogoImageView, signInAppDescriptionLabel ,signInButton, activityIndicatorView].map {
            self.view.addSubview($0)
        }
        
        
        
        signInLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
                
        signInAppDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalTo(signInLogoImageView)
            $0.top.equalTo(signInLogoImageView.snp.bottom).offset(10)
        }
        
        signInButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-54)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
    }
    
    
    public override func bind(reactor: SignInViewReactor) {
        
        Observable.just(())
            .map { Reactor.Action.didShowSignInView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isLoading)
            .observe(on: MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        
        signInButton.rx
            .tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                guard let makeURL = vc.makeGitHubSignInEndPoint(NetWorkCofigure(networkAPi: .signInCode), query: [
                    "client_id": NetWorkCofigure.clientId,
                    "scope": NetWorkCofigure.scope
                ]) else { return }
                
                let commonWebViewController = CommonWebDIContainer(webLoadURL: makeURL).makeViewController()
                commonWebViewController.modalPresentationStyle = .fullScreen
                vc.present(commonWebViewController, animated: true)
            }).disposed(by: disposeBag)
        
    }
        
    
}


extension SignInViewController {
    
    private func makeGitHubSignInEndPoint(_ endPoint: NetWorkCofigure, query: [String: String]) -> URL? {
        
        var queryItem: [URLQueryItem] = []
        guard var baseComponents = URLComponents(string: endPoint.baseURL + endPoint.path) else {
            GitComingAlert.shared
                .setTitle("유효하지 않은 URL 입니다.")
                .show()
                .confirmHandler = { [weak self] in
                    self?.dismiss(animated: true)
                }
            return nil
        }
       
        _ = query.map { key, value in
            queryItem.append(URLQueryItem(name: key, value: value))
        }
        
        baseComponents.queryItems = queryItem
        return baseComponents.url
    }
    
    
}
