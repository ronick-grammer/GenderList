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
        
        register(TabCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension TabCollectionView: Bindable {
    
    func bind() {
        output.tabs
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: TabCollectionViewCell.self))
        { index, item, cell in
            cell.setTitle(item, isFirstTab: index == 0)
        }.disposed(by: disposeBag)
    }
}
