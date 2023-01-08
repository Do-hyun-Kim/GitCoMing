//
//  CommonWebViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import WebKit
import Then
import SnapKit

import RxSwift
import RxCocoa
import Alamofire

public final class CommonWebViewController: BaseViewController<CommonWebViewReactor> {
    
    //MARK: Property
    private lazy var webView: WKWebView = {
        let webViewConfigure = WKWebViewConfiguration()
        webViewConfigure.preferences.javaScriptEnabled = true
        webViewConfigure.preferences.javaScriptCanOpenWindowsAutomatically = true
        return WKWebView(frame: .zero).then {
            $0.uiDelegate = self
            $0.navigationDelegate = self
            $0.scrollView.bounces = false
            $0.scrollView.showsVerticalScrollIndicator = true
            $0.scrollView.showsHorizontalScrollIndicator = false
        }
    }()
    
    override init(reactor: CommonWebViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = webView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    public override func configure() {
        webView.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        DispatchQueue.main.async {
            Task {
                guard let loadUrl = self.reactor?.currentState.gitURL else { return }
                self.webView.load(URLRequest(url: loadUrl))
            }
        }
    }
    
    public override func bind(reactor: CommonWebViewReactor) {
        
        
        Observable.merge(
            webView.rx.didStartLoad.map { _ in true},
            webView.rx.didFinishLoad.map { _ in false}
        )
        .observe(on: MainScheduler.asyncInstance)
        .bind(to: activityIndicatorView.rx.isAnimating)
        .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isWebLoading}
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.gitAccessToken }
            .filter { !$0.accessToken.isEmpty }
            .withUnretained(self)
            .subscribe (onNext: { vc,  _ in
                vc.didUpdateRootViewController()
            }).disposed(by: disposeBag)
            
            
    }
    
    
    private func makeGitHubCallBackUrl(_ request: URLRequest) {
        guard let redirectString = request.url?.absoluteString as? String else { return }
        
        
        if redirectString.starts(with: NetWorkCofigure.redirectUrI) {
            if let redirectCode = redirectString.split(separator: "=").last.map({ String($0) })  {
                self.reactor?.action.onNext(.requestAccessToken(redirectCode))
            }
        }
    }
    
    private func didUpdateRootViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate else { return }
        let postViewController = PostDIContainer().makeViewController()
        let gitNavigationController = GCMNavigationViewController(rootViewController: postViewController)
        
        delegate.window?.rootViewController = gitNavigationController
        delegate.window?.makeKeyAndVisible()
    }
}



extension CommonWebViewController: WKUIDelegate ,WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        GitComingAlert.shared
            .setMessage(message)
            .show()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        
        self.makeGitHubCallBackUrl(navigationAction.request)
        return .allow
    }
}



