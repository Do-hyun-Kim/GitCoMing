//
//  SearchRecentlyKeywordCell.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import UIKit
import Then
import SnapKit

import RxSwift
import RxCocoa
import RxGesture
import ReactorKit

final class SearchRecentlyKeywordCell: BaseCollectionViewCell<SearchRecentlyKeywordCellReactor> {
    
    
    //MARK: Property
    
    private let keywordContainerView = UIView().then {
        $0.backgroundColor = .gitClearGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
    }
    
    private let keywordTitleLabel = UILabel().then {
        $0.textColor = .gitDarkGray
        $0.font = .regular(size: 14)
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.sizeToFit()
    }
    
    private let keywordRemoveImageView = UIImageView().then {
        $0.image = UIImage(named: "keyword_remove")
        $0.contentMode = .scaleAspectFit
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func configure() {
        self.contentView.addSubview(keywordContainerView)
        
        _ = [keywordTitleLabel, keywordRemoveImageView].map {
            keywordContainerView.addSubview($0)
        }
        
        keywordContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        keywordTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.left.equalToSuperview().offset(11)
            $0.height.equalTo(17)
            $0.centerY.equalToSuperview()
        }
        
        keywordRemoveImageView.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.left.equalTo(keywordTitleLabel.snp.right).offset(6)
            $0.right.equalToSuperview().offset(-11)
            $0.centerY.equalTo(keywordTitleLabel)
        }
        
    }
    
    
    override func bind(reactor: SearchRecentlyKeywordCellReactor) {
        reactor.state
            .map { $0.keywordItems }
            .bind(to: keywordTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        keywordTitleLabel
            .rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                guard let indexPath = self.reactor?.currentState.indexPath else { return }
                var recentlyKeyword = UserDefaults.standard.stringArray(forKey: .recentlyKeywords)
                SearchKeywordTransformType.event.onNext(.didTapRecentlyKeyword(keyword: recentlyKeyword[indexPath]))
            }).disposed(by: disposeBag)
        
        
        keywordRemoveImageView.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                guard let indexPath = self.reactor?.currentState.indexPath else { return }
                var removeKeyword =  UserDefaults.standard.stringArray(forKey: .recentlyKeywords)
                removeKeyword.remove(at: indexPath)
                UserDefaults.standard.set(removeKeyword, forKey: .recentlyKeywords)
                SearchKeywordTransformType.event.onNext(.refreshKeyWordSection)
            }).disposed(by: disposeBag)
    }
    
    
    
    
    
}
