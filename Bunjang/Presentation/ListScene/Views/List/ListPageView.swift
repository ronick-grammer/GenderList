//
//  ListPageView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

typealias PageInfo = (prev: Int, current: Int)

class ListPageView: UICollectionView {
    
    typealias ViewModel = ListPageViewModel
    
    let cellIdentifier = "ListPageViewCell"
    
    let viewModel = ViewModel()
    
    let input: ViewModel.Input
    
    let output: ViewModel.Output
    
    var disposeBag = DisposeBag()
    
    var columnStyle = ColumnStyle.two
    
    var listViewDelegate: ListViewDelegate?
    
    init(optionButtonTapped: Observable<Void>, tabsInitialized: Observable<[String]>) {
        
        self.input = ViewModel.Input(
            tabsInitialized: tabsInitialized
        )
        
        self.output = viewModel.transform(input: input)
        
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
        layout.minimumLineSpacing = 0
        
        collectionViewLayout = layout
        isPagingEnabled = true
        dataSource = nil
        delegate = self
        
        register(ListPageViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension ListPageView: Bindable {
    
    func bind() {
        output.tabs
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: ListPageViewCell.self))
        { _, item, cell in
            cell.configure(columnStyle: self.columnStyle, tabName: item)
            cell.listView?.listViewDelegate = self.listViewDelegate
        }.disposed(by: disposeBag)
    }
}

extension ListPageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIWindow().screen.bounds.width, height: bounds.height)
    }
}
