//
//  PageCollectionView.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

typealias PageInfo = (prev: Int, current: Int)

final class PageCollectionView: UICollectionView {
    private let cellIdentifier = "ListPageViewCell"
    
    private let pagesRelay = BehaviorRelay<[ListCollectionView]>(value: [])
    private let disposeBag = DisposeBag()
    
    var pageSwiped: Observable<Int> {
        rx.didScroll
            .compactMap { [weak self] _ in self?.visibleIndexPath?.row }
            .distinctUntilChanged()
    }
    
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
        layout.minimumLineSpacing = 0
        
        collectionViewLayout = layout
        isPagingEnabled = true
        dataSource = nil
        delegate = self
        
        register(PageCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func bindInternal() {
        pagesRelay
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: PageCollectionViewCell.self)) { _, listView, cell in
                cell.configure(listView: listView)
            }
            .disposed(by: disposeBag)
    }
    
    func updatePages(_ pages: [ListCollectionView]) {
        pagesRelay.accept(pages)
    }
    
    func scrollToPage(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension PageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIWindow().screen.bounds.width, height: bounds.height)
    }
}
