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
    
    lazy var input = ViewModel.Input(
        tabInitialized: PublishSubject<String>(),
        scrolledToBottom: rx.scrolledToBottom,
        didPullToRefresh: PublishSubject<Void>()
    )
    
    lazy var output = viewModel.transform(input: input)
    
    var disposeBag = DisposeBag()
    
    var listViewDelegate: ListViewDelegate?

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(startRefresh), for: .valueChanged)
        self.refreshControl = refreshControl
        
        setUp()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setColumnStyle(columnStyle: .two)
        
        dataSource = nil
        delegate = nil
        
        register(ListViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func configure(columnStyle: ColumnStyle, tabName: String) {
        input.tabInitialized.onNext(tabName)
        setColumnStyle(columnStyle: columnStyle)
    }
    
    func setColumnStyle(columnStyle: ColumnStyle) {
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
    
    @objc func startRefresh() {
        input.didPullToRefresh.onNext(Void())
        refreshControl?.endRefreshing()
    }
}

extension ListView: Bindable {
    
    func bind() {
        
        output.genderList
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: ListViewCell.self))
        { index, item, cell in
            cell.configure(genderInfo: item)
        }.disposed(by: disposeBag)
        
        rx.itemSelected
            .subscribe(onNext: { indexPath in
                let detailView = DetailView()
                let genderInfo = try? self.output.genderList.value()[indexPath.row]
                detailView.configure(genderInfo: genderInfo)
                
                let detailVC = DetailViewController(detailView: detailView)
                self.listViewDelegate?.pushDetailViewController(detailVC: detailVC)
            }).disposed(by: disposeBag)
    }
}
