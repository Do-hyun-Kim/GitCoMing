//
//  SearchViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/08.
//

import UIKit
import Then
import SnapKit

import ReactorKit
import RxDataSources
import RxGesture



public final class SearchViewController: BaseViewController<SearchViewReactor> {
    
    //MARK: Property
    
    private let repositorySearchBar = UISearchBar().then {
        let attributed = NSAttributedString(string: "찾는 레포지토리 및 사용자를 키워드로 검색해보세요.".localized(), attributes: [
            NSAttributedString.Key.font: UIFont.regular(size: 14),
            NSAttributedString.Key.foregroundColor: UIColor.gitSilverGray!
        ])
        
        $0.showsCancelButton = false
        $0.searchTextField.attributedPlaceholder = attributed
        $0.searchBarStyle = .minimal
    }
    
    private lazy var searchCollectionViewLayout = GCMLeftAlignedCollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    
    private lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: searchCollectionViewLayout).then {
        $0.register(SearchRecentlyKeywordCell.self, forCellWithReuseIdentifier: "SearchRecentlyKeywordCell")
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    private lazy var searchDataSources: RxCollectionViewSectionedReloadDataSource<SearchSection> = .init(configureCell: { datasource, collectionView, indexPath, sectionItem in
        
        switch sectionItem {
    case let .recentlyKeywordItem(cellReactor):
        guard let recentlyKeywordCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchRecentlyKeywordCell", for: indexPath) as? SearchRecentlyKeywordCell else { return UICollectionViewCell() }
        
        recentlyKeywordCell.reactor = cellReactor
        return recentlyKeywordCell
    }
    })
    
    override init(reactor: SearchViewReactor?) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(#function)
    }
    
    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configure()
        
    }
    
    //MARK: Configure
    public override func configure() {
        _ = [repositorySearchBar, searchCollectionView, activityIndicatorView].map {
            self.view.addSubview($0)
        }
        
        if let searchTextFiled = repositorySearchBar.value(forKey: "searchField") as? UITextField {
            searchTextFiled.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalTo(44)
            }
        }
        
        repositorySearchBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(44)
        }
        
        searchCollectionView.snp.makeConstraints {
            $0.top.equalTo(repositorySearchBar.snp.bottom)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview()
        }
        
        activityIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        
    }
    
    
    public override func bind(reactor: SearchViewReactor) {
        
        Observable.just(())
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        repositorySearchBar.searchTextField
            .rx.value
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateKeyword($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        repositorySearchBar.rx.searchButtonTap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { vc, keyword in
                UserDefaults.standard.setRecentlyKeyWord(keyword: keyword)
                SearchKeywordTransformType.event.onNext(.refreshKeyWordSection)
                vc.navigationController?.popViewController(animated: true, completion: {
                    NotificationCenter.default.post(name: .searchToPost, object: keyword)
                })
            }).disposed(by: disposeBag)
        
        
        searchCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$keywordSection)
            .observe(on: MainScheduler.instance)
            .bind(to: searchCollectionView.rx.items(dataSource: self.searchDataSources))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.keyword }
            .bind(to: repositorySearchBar.searchTextField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSearchLoading }
            .bind(to: activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
    
}




extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
}
