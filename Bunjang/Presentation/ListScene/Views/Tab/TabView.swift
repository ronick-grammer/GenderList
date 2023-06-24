//
//  TabView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

class TabView: UICollectionView {
    
    let cellIdentifier = "TabViewCell"
    
    let viewModel = TabViewModel()
    
    var disposeBag = DisposeBag()
    
    private var tabNames: [String] {
        ["남자", "여자"]
    }
    
    private let colorEvent = PublishSubject<[UIColor]>()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        setUp()
        bind()
        
        colorEvent.onNext(colors)
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
        
        register(TabViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
}

extension TabView {
    func bind() {
        colorEvent
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: TabViewCell.self))
        { index, item, cell in
            cell.setTitle(self.tabNames[index])
        }.disposed(by: disposeBag)
        
        rx.itemSelected
            .bind { indexPath in
                print(indexPath.row)
            }.disposed(by: disposeBag)
    }
}

extension Reactive where Base: TabView {
    var tabButtonTapped: Observable<PageInfo> {
        base.rx.itemSelected
            .map { 
                let currentPage = $0.row
                let previousPage = base.viewModel.pageInfo.prev
                
                if base.viewModel.pageInfo.current != currentPage {
                    base.viewModel.pageInfo.prev = base.viewModel.pageInfo.current
                    base.viewModel.pageInfo.current = currentPage
                }
                
                return (prev: previousPage, current: currentPage)
            }
    }
    
    var selectedTab: Binder<PageInfo> {
        Binder(self.base) { tabView, pageInfo in
            let prevCell = tabView.cellForItem(at: IndexPath(row: pageInfo.prev, section: 0)) as? TabViewCell
            prevCell?.contentView.backgroundColor = .yellow
            
            let currentCell = tabView.cellForItem(at: IndexPath(row: pageInfo.current, section: 0)) as? TabViewCell
            currentCell?.contentView.backgroundColor = .green
        }
    }
}


let colors: [UIColor] = [
    .green,
    .yellow
]
