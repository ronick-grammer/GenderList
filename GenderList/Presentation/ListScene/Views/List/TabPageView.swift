//
//  TabPageView.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TabPageView: UIView {
    private let tabCollectionView = TabCollectionView()
    private let pageCollectionView = PageCollectionView()
    
    private let columnStyleButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let tabs: [String]
    
    private let listCollectionViews: [String: ListCollectionView]
    
    var tabTapped: Observable<Int> { tabCollectionView.tabTapped }
    var pageSwiped: Observable<Int> { pageCollectionView.pageSwiped }
    var columnStyleTapped: Observable<Void> { columnStyleButton.rx.tap.asObservable() }
    
    var itemTapped: Observable<(genderType: String, indexPath: IndexPath)> {
        Observable.merge(tabs.map { tab in
            listCollectionViews[tab]!.itemTapped.map { (genderType: tab, indexPath: $0) }
        })
    }
    
    var scrolledToBottom: Observable<String> {
        Observable.merge(tabs.map { tab in
            listCollectionViews[tab]!.scrolledToBottom.map { _ in tab }
        })
    }
    
    var pullToRefresh: Observable<String> {
        Observable.merge(tabs.map { tab in
            listCollectionViews[tab]!.pullToRefresh.map { _ in tab }
        })
    }
    
    init(tabs: [String]) {
        self.tabs = tabs
        var dict: [String: ListCollectionView] = [:]
        
        for tab in tabs {
            dict[tab] = ListCollectionView()
        }
        
        self.listCollectionViews = dict
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubview(tabCollectionView)
        tabCollectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        addSubview(pageCollectionView)
        pageCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(tabCollectionView.snp.bottom).offset(30)
        }
        
        addSubview(columnStyleButton)
        columnStyleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
        
        tabCollectionView.updateTabs(tabs)
        pageCollectionView.updatePages(tabs.compactMap { listCollectionViews[$0] })
    }
    
    func applySnapshot(_ snapshot: ListSnapshot, for genderType: String) {
        listCollectionViews[genderType]?.applySnapshot(snapshot)
    }
    
    func updateColumnStyle(_ columnStyle: ColumnStyle) {
        listCollectionViews.values.forEach { $0.updateColumnStyle(columnStyle) }
    }
        
    func updateSelectedTab(_ pageInfo: PageInfo) {
        tabCollectionView.updateSelectedTab(pageInfo)
    }
    
    func scrollToPage(_ index: Int) {
        pageCollectionView.scrollToPage(index)
    }
}
