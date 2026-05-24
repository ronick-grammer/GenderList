//
//  TabView.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

final class TabCollectionView: UICollectionView {
    private let cellIdentifier = "TabViewCell"
    
    private let tabsRelay = BehaviorRelay<[String]>(value: [])
    private let disposeBag = DisposeBag()
    
    var tabTapped: Observable<Int> { rx.itemSelected.map { $0.row } }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        setUp()
        bindInternal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIWindow().screen.bounds.width / 2, height: 70)
        layout.minimumLineSpacing = 0
        collectionViewLayout = layout
        
        isScrollEnabled = false
        dataSource = nil
        delegate = nil
        
        register(TabCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func bindInternal() {
        tabsRelay
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: TabCollectionViewCell.self)) { index, item, cell in
                cell.setTitle(item, isFirstTab: index == 0)
            }
            .disposed(by: disposeBag)
    }
    
    func updateTabs(_ tabs: [String]) {
        tabsRelay.accept(tabs)
    }
    
    func updateSelectedTab(_ pageInfo: PageInfo) {
        let prevCell = cellForItem(at: IndexPath(row: pageInfo.prev, section: 0)) as? TabCollectionViewCell
        prevCell?.changeTitleColor(to: .gray)
        
        let currentCell = cellForItem(at: IndexPath(row: pageInfo.current, section: 0)) as? TabCollectionViewCell
        currentCell?.changeTitleColor(to: .black)
    }
}
