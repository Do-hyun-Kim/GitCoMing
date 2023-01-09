//
//  RepositoryEmptyView.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import UIKit
import SnapKit
import Then


final class RepositoryEmptyView: BaseView {
    
    
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
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        _ = [emptyDescriptionLogo, emptyDescriptionLabel].map {
            self.addSubview($0)
        }
        
        emptyDescriptionLogo.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        emptyDescriptionLabel.snp.makeConstraints {
            $0.centerX.equalTo(emptyDescriptionLogo)
            $0.top.equalTo(emptyDescriptionLogo.snp.bottom).offset(10)
        }
    }
    
}
