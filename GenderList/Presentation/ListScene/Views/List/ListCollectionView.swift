//
//  ListCollectionView.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift

protocol ListViewDelegate {
    func pushDetailViewController(detailVC: DetailViewController)
}

final class ListCollectionView: UICollectionView {
    
    private let cellIdentifier = "ListViewCell"
    
    typealias ViewModel = ListViewModel
    
    let viewModel = ViewModel()
    
    lazy var input = ViewModel.Input(
        tabInitialized: PublishSubject<String>(),
        scrolledToBottom: rx.scrolledToBottom,
        didPullToRefresh: PublishSubject<Void>(),
        itemTapped: rx.itemSelected.asObservable(),
        selectButtonTapped: PublishSubject<Observable<Bool>>(),
        removeBarButtonTapped: PublishSubject<Observable<Void>>()
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
        
        register(ListCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
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
    
    func setListViewDelegate(listViewDelegate: ListViewDelegate?) {
        self.listViewDelegate = listViewDelegate
    }
    
    func setSelectButtonTapped(selectButtonTapped: Observable<Bool>) {
        input.selectButtonTapped.onNext(selectButtonTapped)
    }
    
    func setRemoveBarButtonTapped(removeBarButtonTapped: Observable<Void>) {
        input.removeBarButtonTapped.onNext(removeBarButtonTapped)
    }
    
    @objc func startRefresh() {
        input.didPullToRefresh.onNext(Void())
        refreshControl?.endRefreshing()
    }
}

extension ListCollectionView: Bindable {
    
    func bind() {
        
        output.genderList
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: ListCollectionViewCell.self))
        { index, item, cell in
            cell.configure(genderInfo: item, isSelected: self.viewModel.isSelected(index: index))
        }.disposed(by: disposeBag)
        
        output.genderListError
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] message in
                self?.makeToast("  리스트를 불러오는데 실패하였습니다. 다시 시도해 주세요        ", withDuration: 2, delay: 1.5)
            }.disposed(by: disposeBag)
        
        // 선택한 리스트 마킹 처리
        output.markItem
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { indexPath in
                let cell = self.cellForItem(at: indexPath) as! ListCollectionViewCell
                cell.itemTapped()
            }).disposed(by: disposeBag)
        
        // 디테일 성별 리스트 화면 이동
        output.moveToDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { genderInfo in
                let detailView = DetailView()
                detailView.configure(genderInfo: genderInfo)
                
                let detailVC = DetailViewController(detailView: detailView)
                self.listViewDelegate?.pushDetailViewController(detailVC: detailVC)
            }).disposed(by: disposeBag)
        
        output.cancelSelectedList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.viewModel.removeAllSelectedItems()
                self.reloadData()
            }).disposed(by: disposeBag)
    }
}
