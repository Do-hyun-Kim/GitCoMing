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

public final class CommonWebViewController: BaseViewController<CommonWebViewReactor> {
    
    //MARK: Property
    private lazy var webView: WKWebView = {
        let webViewConfigure = WKWebViewConfiguration()
        webViewConfigure.websiteDataStore = WKWebsiteDataStore.default()
        
        return WKWebView(frame: .zero).then {
            $0.uiDelegate = self
            $0.navigationDelegate = self
            $0.scrollView.bounces = false
            $0.scrollView.showsVerticalScrollIndicator = true
            $0.scrollView.showsHorizontalScrollIndicator = false
        }
    }()
    
    override init(reactor: CommonWebViewReactor? = nil) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public override func loadView() {
        self.view = webView
    }
    
    public override func configure() {
        self.webView.addSubview(activityIndicatorView)
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public override func bind(reactor: CommonWebViewReactor) {
        
        
        Observable.merge(
            webView.rx.didStartLoad.map { _ in true},
            webView.rx.didFinishLoad.map { _ in false},
            webView.rx.didFailLoad.map { _ in false}
        )
        .observe(on: MainScheduler.asyncInstance)
        .bind(to: activityIndicatorView.rx.isAnimating)
        .disposed(by: disposeBag)
        
        
        guard let loadUrl = self.reactor?.currentState.gitURL else { return }
        self.webView.load(URLRequest(url: loadUrl))
    }
}



extension CommonWebViewController: WKUIDelegate ,WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        GitComingAlert.shared
            .setMessage(message)
            .show()
            .confirmHandler = {
                completionHandler(true)
            }
    }
    
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        guard let redirectUrl = webView.url?.absoluteURL else { return }
    }
    
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        
        if !url.absoluteString.hasPrefix("https://") {
            decisionHandler(.allow)
        }
        decisionHandler(.allow)
    }
        
}
