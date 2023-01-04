//
//  LoginViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import UIKit
import Then
import SnapKit



final class LoginViewController: UIViewController {
    
    //MARK: Property
    private let loginLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "splashLogo")
        $0.contentMode = .scaleAspectFill
    }
    
    private let loginAppDescriptionLabel = UILabel().then {
        $0.font = .bold(size: 24)
        $0.textColor = .darkGray
        $0.text = "GitCoMing"
        $0.sizeToFit()
    }
    
    
    private let loginButton = UIButton(type: .custom).then {
        $0.layer.cornerRadius = 5
        $0.setTitle("Sign in with GitHub", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.darkGray
        $0.semanticContentAttribute = .forceLeftToRight
    }
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        _ = [loginLogoImageView,loginAppDescriptionLabel, loginButton].map {
            self.view.addSubview($0)
        }
        
        loginLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        loginAppDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalTo(loginLogoImageView)
            $0.top.equalTo(loginLogoImageView.snp.bottom).offset(10)
        }
        
        loginButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-54)
        }
        
    }
    
    
}
