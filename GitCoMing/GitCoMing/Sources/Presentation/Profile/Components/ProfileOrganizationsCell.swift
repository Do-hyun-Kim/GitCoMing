//
//  ProfileOrganizationsCell.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import UIKit
import Then
import SnapKit

import RxCocoa
import RxSwift
import ReactorKit


final class ProfileOrganizationsCell: BaseCollectionViewCell<ProfileOrganizationsCellReactor> {
        
    
    private let organizationsImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = false
    }
    
    private let organizationsDescriptionLabel = UILabel().then {
        $0.textColor = .gitDarkGray
        $0.font = .bold(size: 14)
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.numberOfLines = 1
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: Configure
    override func configure() {
        
        _ = [organizationsImageView, organizationsDescriptionLabel].map {
            self.addSubview($0)
        }
        
        
        organizationsImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        organizationsDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(organizationsImageView.snp.bottom).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(24)
            $0.centerX.equalTo(organizationsImageView)
        }
        
    }
    
    
    override func bind(reactor: ProfileOrganizationsCellReactor) {
        reactor.state
            .map { $0.organizationsItem.organizationsName }
            .observe(on: MainScheduler.instance)
            .bind(to: organizationsDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.organizationsItem.transformOrganizationsURL() }
            .map { UIImage(data: try Data(contentsOf: $0))}
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: organizationsImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    
    
}

