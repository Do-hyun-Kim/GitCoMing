//
//  PostRepositoryListCell.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import UIKit
import Then
import SnapKit

import ReactorKit
import RxGesture
import RxSwift
import RxCocoa

final class PostRepositoryListCell: BaseCollectionViewCell<PostRepositoryCellReactor> {
    
    
    //MARK: Property
    private let repositoryContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 13
        $0.layer.borderColor = UIColor.gitDimGray?.cgColor
        $0.layer.borderWidth = 1
        
    }
    
    private let repositoryTitleLabel = UILabel().then {
        $0.textColor = .gitDarkGray
        $0.font = .semiBold(size: 16)
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    
    private let repositoryDescriptionLabel = UILabel().then {
        $0.textColor = .gitBlack
        $0.font = .regular(size: 14)
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
    }
    
    private let repositoryOwnerImageView = UIImageView().then {
        $0.image = UIImage(named: "owner")
        $0.contentMode = .scaleToFill
    }
    
    private let repositoryOwnerLable = UILabel().then {
        $0.textColor = .gitGray
        $0.font = .regular(size: 12)
        $0.textAlignment = .left
        $0.sizeToFit()
        $0.numberOfLines = 1
    }
    
    private let repositoryStarContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let repositoryStarCountLabel = UILabel().then {
        $0.textColor = .gitDarkGray
        $0.font = .regular(size: 11)
        $0.sizeToFit()
        $0.textAlignment = .center
    }
    
    private let repositoryStarImageView = UIImageView().then {
        $0.image = UIImage(named: "unstar")
        $0.contentMode = .scaleToFill
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
        
        self.contentView.addSubview(repositoryContainerView)
        
        repositoryStarContainerView.addSubview(repositoryStarImageView)

        _ = [repositoryTitleLabel, repositoryDescriptionLabel, repositoryStarContainerView, repositoryStarCountLabel , repositoryOwnerLable, repositoryOwnerImageView].map {
            repositoryContainerView.addSubview($0)
        }
        
        repositoryContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        repositoryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.height.equalTo(18)
        }
        
        repositoryDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(repositoryTitleLabel.snp.bottom).offset(8)
            $0.left.equalTo(repositoryTitleLabel)
            $0.bottom.equalTo(repositoryOwnerLable.snp.top).offset(-10)
            $0.right.equalToSuperview().offset(-16)
        }
        
        repositoryOwnerImageView.snp.makeConstraints {
            $0.left.equalTo(repositoryTitleLabel)
            $0.height.width.equalTo(16)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        repositoryOwnerLable.snp.makeConstraints {
            $0.left.equalTo(repositoryOwnerImageView.snp.right).offset(5)
            $0.height.equalTo(14)
            $0.centerY.equalTo(repositoryOwnerImageView)
        }
        
        repositoryStarCountLabel.snp.makeConstraints {
            $0.top.equalTo(repositoryTitleLabel)
            $0.width.height.equalTo(20)
            $0.centerY.equalTo(repositoryStarContainerView)
        }
        
        repositoryStarContainerView.snp.makeConstraints {
            $0.top.equalTo(repositoryTitleLabel)
            $0.right.equalToSuperview().offset(-20)
            $0.left.greaterThanOrEqualTo(repositoryStarCountLabel.snp.right).offset(5)
            $0.width.height.equalTo(20)
        }
        
        repositoryStarImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    override func bind(reactor: PostRepositoryCellReactor) {
        
        
        repositoryStarContainerView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { _ in Reactor.Action.didTapStarButton}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
            
        
        
        reactor.state
            .map { $0.repositoryItems.repositoryName }
            .observe(on: MainScheduler.instance)
            .bind(to: repositoryTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.repositoryItems.repositoryDescription }
            .observe(on: MainScheduler.instance)
            .bind(to: repositoryDescriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.repositoryItems.repositoryOwner.ownerName }
            .observe(on: MainScheduler.instance)
            .bind(to: repositoryOwnerLable.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { String($0.repositoryItems.repositoryStarCount) }
            .observe(on: MainScheduler.instance)
            .bind(to: repositoryStarCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        
    }
    
    
}
