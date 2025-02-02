//
//  TabPageView.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

final class TabPageView: UIView {
    
    private let tabCollectionView: TabCollectionView
    
    private let pageCollectionView: PageCollectionView
    
    private let columnStyleButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    var viewModel = TabListViewModel()
    
    let input: ViewModel.Input
    
    let output: ViewModel.Output
    
    let disposeBag = DisposeBag()
    
    init(selectBarButtonTapped: Observable<Bool>, removeBarButtonTapped: Observable<Void>) {
        // TODO: Enum화 작업
        let tabInitialized = Observable<[String]>.just(["male", "female"])
        
        pageCollectionView = PageCollectionView(
            optionButtonTapped: columnStyleButton.rx.tap.asObservable(),
            tabsInitialized: tabInitialized,
            selectBarButtonTapped: selectBarButtonTapped,
            removeBarButtonTapped: removeBarButtonTapped
        )
        
        tabCollectionView = TabCollectionView(
            tabsInitialized: tabInitialized
        )
        
        input = ViewModel.Input(
            columnStyleButtonTapped: columnStyleButton.rx.tap.asObservable(),
            tabButtonTapped: tabCollectionView.rx.tabButtonTapped,
            pageSwiped: pageCollectionView.rx.pageSwiped
        )
        
        output = viewModel.transform(input: input)
        
        super.init(frame: .zero)
        
        setUp()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
        addSubview(tabCollectionView)
        tabCollectionView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        addSubview(pageCollectionView)
        pageCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(tabCollectionView.snp.bottom).offset(30)
        }
        
        addSubview(columnStyleButton)
        columnStyleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func setListViewDelegate(listViewDelegate: ListViewDelegate) {
        pageCollectionView.listViewDelegate = listViewDelegate
    }
}

extension TabPageView: Bindable {
    func bind() {
        // 탭 리스트 화면 구성
        output.columnStyle
            .bind(to: pageCollectionView.rx.columnStyle)
            .disposed(by: disposeBag)
        
        // 스와이프한 방향의 탭 선택
        output.selectedTab
            .bind(to: tabCollectionView.rx.selectedTab)
            .disposed(by: disposeBag)
        
        // 탭 선택시 해당 리스트 화면으로 이동
        output.pageScrollTo
            .bind(to: pageCollectionView.rx.selectedPage)
            .disposed(by: disposeBag)
    }
}
