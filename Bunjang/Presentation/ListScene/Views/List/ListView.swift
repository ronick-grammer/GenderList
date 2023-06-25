//
//  ListView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift

protocol ListViewDelegate {
    func pushDetailViewController(detailVC: DetailViewController)
}

class ListView: UICollectionView {
    
    private let cellIdentifier = "ListViewCell"
    
    typealias ViewModel = ListViewModel
    
    let viewModel = ViewModel()
    
    let input: ViewModel.Input
    
    let output: ViewModel.Output
    
    var disposeBag = DisposeBag()
    
    var listViewDelegate: ListViewDelegate?
    
    private var genderList: [Gender] = []
    
    init(tab: String) {
        input = ViewModel.Input(
            tabInitialized: Observable<String>.just(tab)
        )
        
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
        layout.itemSize = CGSize(width: UIWindow().screen.bounds.width / 2 - 15, height: 300)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionViewLayout = layout
        
        dataSource = nil
        delegate = nil
        
        register(ListViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func configure(columnStyle: ColumnStyle) {
        setColumnStyle(columnStyle: columnStyle)
    }
    
    func setColumnStyle(columnStyle: ColumnStyle) {
        switch columnStyle {
        case .one:
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIWindow().screen.bounds.width - 20, height: 200)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            self.collectionViewLayout = layout
            
        case .two:
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: UIWindow().screen.bounds.width / 2 - 15, height: 200)
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            self.collectionViewLayout = layout
        }
    }
}

extension ListView: Bindable {
    
    func bind() {
        
        output.genderList
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: ListViewCell.self))
        { index, item, cell in
            cell.configure(genderInfo: item)
            self.genderList.append(item)
        }.disposed(by: disposeBag)
        
        rx.itemSelected
            .subscribe(onNext: { indexPath in
                let detailView = DetailView()
                detailView.configure(genderInfo: self.genderList[indexPath.row])
                
                let detailVC = DetailViewController(detailView: detailView)
                self.listViewDelegate?.pushDetailViewController(detailVC: detailVC)
            }).disposed(by: disposeBag)
    }
}
