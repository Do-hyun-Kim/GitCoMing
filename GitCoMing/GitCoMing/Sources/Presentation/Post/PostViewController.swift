//
//  SearchViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import UIKit
import SnapKit
import Then

import RxSwift
import RxCocoa
import RxGesture
import ReactorKit
import RxDataSources


public final class PostViewController: BaseViewController<PostViewReactor> {

    
    //MARK: Property
    
    private let searchView: SearchView = SearchView().then {
        $0.layer.borderColor = UIColor.gitLightGray?.cgColor
        $0.layer.borderWidth = 2
    }
    
    private let postEmptyView: RepositoryEmptyView = RepositoryEmptyView().then {
        $0.backgroundColor = .white
    }
    
    private let postRepositoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }).then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .gitClearGray
        $0.register(PostRepositoryListCell.self, forCellWithReuseIdentifier: "PostRepositoryListCell")
    }
    
    private var profileButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "profile"), for: .normal)
        $0.contentMode = .scaleToFill
    }
    
    private lazy var postProfileButtonItem = UIBarButtonItem(customView: profileButton)
    
    
    private let postDataSources: RxCollectionViewSectionedReloadDataSource<PostSection> = .init(configureCell: { datasource, collectionView, indexPath, sectionItem in
        switch sectionItem {
    case let .repositoryItem(cellReactor):
        guard let repositoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostRepositoryListCell", for: indexPath) as? PostRepositoryListCell else { return UICollectionViewCell() }
        repositoryCell.reactor = cellReactor
        return repositoryCell
        }
    })
    
    
    override init(reactor: PostViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.navigationItem.rightBarButtonItem = postProfileButtonItem
        self.view.backgroundColor = .white
    }
    
    
    
    //MARK: Configure
    public override func configure() {
        
        _ = [searchView, postRepositoryCollectionView, postEmptyView, activityIndicatorView].map {
            self.view.addSubview($0)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
        }
        
        postRepositoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        postEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(10)
            $0.left.right.bottom.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    
    public override func bind(reactor: PostViewReactor) {
        
        Observable.just(())
            .map{ Reactor.Action.viewDidLoad}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        postRepositoryCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        searchView.rx
            .tapGesture()
            .when(.recognized)
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                let searchViewController = SearchDIContainer().makeViewController()
                vc.navigationController?.pushViewController(searchViewController, animated: true)
            }.disposed(by: disposeBag)
        
        
        profileButton.rx
            .tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                let profileViewController = ProfileDIContainer().makeViewController()
                vc.navigationController?.pushViewController(profileViewController, animated: true)
            }.disposed(by: disposeBag)
        
        
        NotificationCenter.default.rx
            .notification(.searchToPost)
            .withUnretained(self)
            .subscribe(onNext: { vc, userInfo in
                guard let searchKeyword = userInfo.object as? String else { return }
                PostTransformType.event.onNext(.searchToKeyword(keyword: searchKeyword))
            }).disposed(by: disposeBag)
        
        reactor.pulse(\.$section)
            .observe(on: MainScheduler.instance)
            .bind(to: postRepositoryCollectionView.rx.items(dataSource: self.postDataSources))
            .disposed(by: disposeBag)
        
        reactor.state
            .map{ $0.isLoading }
            .observe(on: MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.repositoryItem }
            .map { !$0.isEmpty }
            .bind(to: postEmptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.isSearchPageLoading }
            .observe(on: MainScheduler.instance)
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    
    
}


extension PostViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 40, height: 97)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}


extension PostViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = scrollView.frame.height
        let scrollContentHeight = scrollView.contentSize.height
        if scrollView.contentOffset.y + scrollHeight >= scrollContentHeight  {
            if !(self.reactor?.currentState.isSearchPageLoading ?? false) {
                self.reactor?.action.onNext(.updateSearchPage(10, !(self.reactor?.currentState.isSearchPageLoading ?? false)))
            }
        }
    }
}
