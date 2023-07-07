//
//  PageCollectionView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

typealias PageInfo = (prev: Int, current: Int)

final class PageCollectionView: UICollectionView {
    
    typealias ViewModel = ListPageViewModel
    
    let cellIdentifier = "ListPageViewCell"
    
    let viewModel = ViewModel()
    
    let input: ViewModel.Input
    
    let output: ViewModel.Output
    
    var disposeBag = DisposeBag()
    
    var listViewDelegate: ListViewDelegate?
    
    var selectBarButtonTapped: Observable<Bool>
    
    var removeBarButtonTapped: Observable<Void>

    init(optionButtonTapped: Observable<Void>, tabsInitialized: Observable<[String]>, selectBarButtonTapped: Observable<Bool>, removeBarButtonTapped: Observable<Void>) {
        
        self.input = ViewModel.Input(
            tabsInitialized: tabsInitialized
        )
        
        self.output = viewModel.transform(input: input)
        
        self.selectBarButtonTapped = selectBarButtonTapped
        
        self.removeBarButtonTapped = removeBarButtonTapped
        
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
        
        register(PageCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension PageCollectionView: Bindable {
    
    func bind() {
        output.tabs
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: PageCollectionViewCell.self))
        { _, item, cell in
            cell.configure(columnStyle: self.viewModel.columnStyle, tabName: item)
            cell.setListViewDelegate(listViewDelegate: self.listViewDelegate)
            cell.setSelectButtonTapped(selectButtonTapped: self.selectBarButtonTapped)
            cell.setRemoveBarButtonTapped(removeBarButtonTapped: self.removeBarButtonTapped)
        }.disposed(by: disposeBag)
    }
}

extension PageCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIWindow().screen.bounds.width, height: bounds.height)
    }
}
