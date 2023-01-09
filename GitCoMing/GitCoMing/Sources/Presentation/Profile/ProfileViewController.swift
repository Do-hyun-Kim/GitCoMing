//
//  ProfileViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/09.
//

import UIKit
import Then
import SnapKit

import ReactorKit
import RxDataSources
import RxSwift
import RxCocoa
import RxGesture


public final class ProfileViewController: BaseViewController<ProfileViewReactor> {
    
    
    //MARK: Property
    private var userSearchView: SearchView = SearchView(placeHolderDescription: "유저를 검색해 보세요.".localized()).then {
        $0.layer.borderColor = UIColor.gitLightGray?.cgColor
        $0.layer.borderWidth = 2
    }
    
    
    private let userInfoContainerView = UIView().then {
        $0.backgroundColor = .gitWhite
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.gitBlack?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
    }
    
    
    private let userProfileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    
    private let userProfileNameLabel = UILabel().then {
        $0.textColor = .gitBlack
        $0.font = .semiBold(size: 18)
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.numberOfLines = 1
    }
    
    private let userFollwerCountLabel = UILabel().then {
        $0.textColor = .gitBlack
        $0.font = .bold(size: 44)
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.numberOfLines = 1
    }
    
    private let userFollwingCountLabel = UILabel().then {
        $0.textColor = .gitBlack
        $0.font = .bold(size: 44)
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.numberOfLines = 1
    }
    
    private let userFollwerDescriptionLabel = UILabel().then {
        $0.textColor = .gitDarkGray
        $0.text = "followers".localized()
        $0.font = .bold(size: 18)
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.numberOfLines = 1
    }
    
    private let userFollwingDescriptionLabel = UILabel().then {
        $0.textColor = .gitDarkGray
        $0.text = "following".localized()
        $0.font = .semiBold(size: 18)
        $0.textAlignment = .center
        $0.sizeToFit()
        $0.numberOfLines = 1
    }
    
    private let organizationsFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = .zero
        $0.minimumInteritemSpacing = 10
    }
    
    private lazy var organizationsCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: organizationsFlowLayout).then {
        $0.register(ProfileOrganizationsCell.self, forCellWithReuseIdentifier: "ProfileOrganizationsCell")
        $0.backgroundColor = .gitWhite
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 15
        $0.layer.shadowColor = UIColor.gitBlack?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 4
        $0.layer.shadowOpacity = 0.3
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = true
    }
    
    
    private lazy var organizationsDataSources: RxCollectionViewSectionedReloadDataSource<ProfileSection> = .init(configureCell: { datasource, collectionView, indexPath, sectionItem in
        
        switch sectionItem {
        case let .organizationsItem(cellReactor):
            guard let organizationsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileOrganizationsCell", for: indexPath) as? ProfileOrganizationsCell else { return UICollectionViewCell() }
            organizationsCell.reactor = cellReactor
            organizationsCell.layoutIfNeeded()
            return organizationsCell
        }
        
    })
    
    
    override init(reactor: ProfileViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillLayoutSubviews() {
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height / 2.0
    }
    
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configure()
    }
    
    //MARK: Configure
    public override func configure() {
        
        _ = [userSearchView, userInfoContainerView, organizationsCollectionView, activityIndicatorView].map {
            self.view.addSubview($0)
        }
        
        _ = [userProfileImageView, userProfileNameLabel, userFollwerCountLabel, userFollwingCountLabel, userFollwerDescriptionLabel, userFollwingDescriptionLabel].map {
            userInfoContainerView.addSubview($0)
        }
        
        userSearchView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
        }
        
        userInfoContainerView.snp.makeConstraints {
            $0.top.equalTo(userSearchView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(150)
            
        }
        
        userProfileNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.height.equalTo(24)
        }
        
        userProfileImageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalTo(userProfileNameLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(userProfileNameLabel)
        }
        
        userFollwerCountLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileNameLabel)
            $0.left.equalTo(userFollwerDescriptionLabel)
            $0.width.equalTo(80)
            $0.centerY.equalToSuperview()
        }
        
        userFollwingCountLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileNameLabel)
            $0.right.equalToSuperview().offset(-20)
            $0.width.equalTo(80)
            $0.centerY.equalToSuperview()
        }
        
        userFollwerDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(userFollwerCountLabel.snp.bottom).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(24)
            $0.left.equalTo(userProfileImageView.snp.right).offset(30)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        userFollwingDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(userFollwingCountLabel.snp.bottom).offset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(24)
            $0.left.equalTo(userFollwerCountLabel.snp.right).offset(30)
            $0.bottom.equalTo(userFollwerDescriptionLabel)
        }
        
        organizationsCollectionView.snp.makeConstraints {
            $0.top.equalTo(userInfoContainerView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(150)
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
    }
    
    
    public override func bind(reactor: ProfileViewReactor) {
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        userSearchView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, _ in
                let searchViewController = SearchDIContainer().makeViewController()
                vc.navigationController?.pushViewController(searchViewController, animated: true)
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.searchToPost)
            .withUnretained(self)
            .subscribe(onNext: { vc, userinfo in
                guard let searchKeywrod = userinfo.object as? String else { return }
                ProfileTransformType.event.onNext(.updateToUser(keyword: searchKeywrod))
                ProfileTransformType.event.onNext(.updateOrganizations(userName: searchKeywrod))
            }).disposed(by: disposeBag)
        
        
        organizationsCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$profileSection)
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: organizationsCollectionView.rx.items(dataSource: self.organizationsDataSources))
            .disposed(by: disposeBag)
        
        reactor.state
            .filter { $0.profileItem != nil }
            .single()
            .subscribe(onNext: { _ in
                ProfileTransformType.event.onNext(.responseUserOrganizations)
            }).disposed(by: disposeBag)
        
        
        reactor.state
            .compactMap { $0.profileItem }
            .map { $0.userName }
            .observe(on: MainScheduler.instance)
            .bind(to: userProfileNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.profileItem }
            .compactMap { $0.transformUserProfileURL() }
            .map { UIImage(data: try Data(contentsOf: $0)) }
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: userProfileImageView.rx.image)
            .disposed(by: disposeBag)
        
        
        
        reactor.state
            .compactMap { $0.profileItem}
            .map { String($0.userFollowers) }
            .observe(on: MainScheduler.instance)
            .bind(to: userFollwerCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.profileItem }
            .map { String($0.userFollowing) }
            .observe(on: MainScheduler.instance)
            .bind(to: userFollwingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isUserProfileLoading }
            .observe(on: MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
    
    
}


extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: 150)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}
