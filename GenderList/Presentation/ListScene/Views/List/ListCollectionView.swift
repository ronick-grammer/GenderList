//
//  ListCollectionView.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

struct ListSnapshot {
    let items: [GenderProfileItemViewModel]
    let isSelectMode: Bool
    let selectedIndexes: Set<Int>
    
    static let empty = ListSnapshot(items: [], isSelectMode: false, selectedIndexes: [])
}

final class ListCollectionView: UICollectionView {
    private let cellIdentifier = "ListViewCell"
    
    private let snapshotRelay = BehaviorRelay<ListSnapshot>(value: .empty)
    private let pullToRefreshSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    var itemTapped: Observable<IndexPath> { rx.itemSelected.asObservable() }
    var scrolledToBottom: Observable<Void> { rx.scrolledToBottom }
    var pullToRefresh: Observable<Void> { pullToRefreshSubject.asObservable() }
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        setUp()
        bindInternal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        updateColumnStyle(.two)
        dataSource = nil
        delegate = nil
        register(ListCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func bindInternal() {
        snapshotRelay
            .map { $0.items }
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: ListCollectionViewCell.self)) { [weak self] index, item, cell in
                let snapshot = self?.snapshotRelay.value
                let isSelected = snapshot?.selectedIndexes.contains(index) ?? false
                cell.configure(profileItem: item, isSelected: isSelected)
            }
            .disposed(by: disposeBag)
    }
        
    func applySnapshot(_ snapshot: ListSnapshot) {
        snapshotRelay.accept(snapshot)
    }
    
    func updateColumnStyle(_ columnStyle: ColumnStyle) {
        let layout = UICollectionViewFlowLayout()
        
        switch columnStyle {
        case .one:
            layout.itemSize = CGSize(width: UIWindow().screen.bounds.width - 20, height: 200)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
        case .two:
            layout.itemSize = CGSize(width: UIWindow().screen.bounds.width / 2 - 15, height: 200)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        self.collectionViewLayout = layout
    }
    
    @objc private func startRefresh() {
        pullToRefreshSubject.onNext(())
        refreshControl?.endRefreshing()
    }
}
