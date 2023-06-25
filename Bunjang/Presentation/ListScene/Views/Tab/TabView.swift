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
    
    typealias ViewModel = TabViewModel
    
    let cellIdentifier = "TabViewCell"
    
    let viewModel = ViewModel()
    
    let input: ViewModel.Input
    
    let output: ViewModel.Output
    
    var disposeBag = DisposeBag()
    
    init(tabsInitialized: Observable<[String]>) {
        input = ViewModel.Input(tabsInitialized: tabsInitialized)
        output = viewModel.transform(input: input)
        
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        setUp()
        bind()
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

extension TabView: Bindable {
    
    func bind() {
        output.tabs
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: TabViewCell.self))
        { index, item, cell in
            cell.setTitle(item, isFirstTab: index == 0)
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
            prevCell?.changeTitleColor(to: .gray)
            
            let currentCell = tabView.cellForItem(at: IndexPath(row: pageInfo.current, section: 0)) as? TabViewCell
            currentCell?.changeTitleColor(to: .black)
        }
    }
}


let colors: [UIColor] = [
    .green,
    .yellow
]
