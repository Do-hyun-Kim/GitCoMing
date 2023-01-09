//
//  SearchView.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import UIKit
import Then
import SnapKit

final class SearchView: BaseView {
    
    
    //MARK: Property
    private(set) var placeHolderDescription: String = ""
    
    private let placeHolderLabel = UILabel().then {
        $0.textColor = .gitSilverGray
        $0.font = .regular(size: 14)
    }
    
    private let searchImageView = UIImageView().then {
        $0.image = UIImage(named: "search")
        $0.contentMode = .scaleToFill
    }
    
    init(placeHolderDescription: String) {
        super.init(frame: .zero)
        self.placeHolderDescription = placeHolderDescription
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
        self.backgroundColor = .gitLightGray
        
        placeHolderLabel.text = placeHolderDescription
        
        _ = [placeHolderLabel, searchImageView].map {
            self.addSubview($0)
        }
        
        searchImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.centerY.equalTo(searchImageView)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(searchImageView.snp.right).offset(5)
        }
    }
    
    
}
