//
//  GenderListViewController.swift
//  GenderList
//
//  Created by Ronick on 6/20/23.
//

import UIKit
import SnapKit
import RxSwift
import ReactorKit

final class GenderListViewController: BaseViewController {
    typealias Reactor = GenderListViewReactor
    
    private let showDetailList: (GenderProfileItemViewModel) -> Void
    private let tabs = ["male", "female"]
    
    private lazy var selectBarButton: UIBarButtonItem = {
        UIBarButtonItem(title: "선택", style: .plain, target: self, action: nil)
    }()
    
    private lazy var removeBarButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let image = UIImage(systemName: "trash", withConfiguration: configuration)
        return UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
    }()
    
    private lazy var tabListView = TabPageView(tabs: tabs)
    
    init(showDetailList: @escaping (GenderProfileItemViewModel) -> Void) {
        self.showDetailList = showDetailList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        navigationController?.navigationBar.topItem?.title = "Gender List"
        navigationItem.rightBarButtonItems = [selectBarButton, removeBarButton]
        
        view.addSubview(tabListView)
    }
    
    override func setupConstraints() {
        tabListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension GenderListViewController: ReactorKit.View {
    func bind(reactor: GenderListViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        selectBarButton.rx.tap
            .map { Reactor.Action.toggleSelectMode }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        removeBarButton.rx.tap
            .map { Reactor.Action.removeSelected }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tabListView.tabTapped
            .map { Reactor.Action.selectTab($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tabListView.pageSwiped
            .map { Reactor.Action.swipePage($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tabListView.columnStyleTapped
            .map { Reactor.Action.toggleColumnStyle }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tabListView.itemTapped
            .map { Reactor.Action.itemTapped(genderType: $0.genderType, indexPath: $0.indexPath) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tabListView.scrolledToBottom
            .map { Reactor.Action.scrolledToBottom(genderType: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tabListView.pullToRefresh
            .map { Reactor.Action.pullToRefresh(genderType: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 최초 양쪽 탭 데이터 로드
        Observable.from(tabs)
            .map { Reactor.Action.configure(genderType: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map { $0.selectButtonTitle }
            .distinctUntilChanged()
            .bind(to: selectBarButton.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.columnStyle }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.tabListView.updateColumnStyle($0) })
            .disposed(by: disposeBag)
        
        let selectedTab: Observable<PageInfo> = reactor.state.map { $0.selectedTab }
        selectedTab
            .distinctUntilChanged { lhs, rhs in lhs.current == rhs.current && lhs.prev == rhs.prev }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.tabListView.updateSelectedTab($0) })
            .disposed(by: disposeBag)
        
        for tab in tabs {
            bindList(reactor: reactor, tab: tab)
        }
        
        reactor.pulse(\.$pageScrollTo)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.tabListView.scrollToPage($0) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$moveToDetail)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.showDetailList($0) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.view.makeToast("리스트를 불러오는데 실패하였습니다. 다시 시도해 주세요", withDuration: 2, delay: 1.5)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindList(reactor: Reactor, tab: String) {
        let snapshot = reactor.state.map { state -> ListSnapshot in
            let sub = state.lists[tab] ?? .init()
            
            return ListSnapshot(
                items: sub.items,
                isSelectMode: state.isSelectMode,
                selectedIndexes: sub.selectedIndexes
            )
        }
        
        snapshot
            .distinctUntilChanged { lhs, rhs in
                let sameMode = lhs.isSelectMode == rhs.isSelectMode
                let sameSelection = lhs.selectedIndexes == rhs.selectedIndexes
                let sameItems = lhs.items.map { $0.email } == rhs.items.map { $0.email }
                return sameMode && sameSelection && sameItems
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] snap in
                self?.tabListView.applySnapshot(snap, for: tab)
            })
            .disposed(by: disposeBag)
    }
}
