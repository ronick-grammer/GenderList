//
//  TabListView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

final class TabListView: UIView {
    
    private let tabView: TabView
    
    private let listPageView: ListPageView
    
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
    
    init() {
        let tabInitialized = Observable<[String]>.just(["male", "female"])
        
        listPageView = ListPageView(
            optionButtonTapped: columnStyleButton.rx.tap.asObservable(),
            tabsInitialized: tabInitialized
        )
        
        tabView = TabView(
            tabsInitialized: tabInitialized
        )
        
        input = ViewModel.Input(
            columnStyleButtonTapped: columnStyleButton.rx.tap.asObservable(),
            tabButtonTapped: tabView.rx.tabButtonTapped,
            pageSwiped: listPageView.rx.pageSwiped
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
        addSubview(tabView)
        tabView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        addSubview(listPageView)
        listPageView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(tabView.snp.bottom).offset(30)
        }
        
        addSubview(columnStyleButton)
        columnStyleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    func setListViewDelegate(listViewDelegate: ListViewDelegate) {
        listPageView.listViewDelegate = listViewDelegate
    }
}

extension TabListView: Bindable {
    func bind() {
        output.columnStyle
            .bind(to: listPageView.rx.columnStyle)
            .disposed(by: disposeBag)
        
        output.selectedTab
            .bind(to: tabView.rx.selectedTab)
            .disposed(by: disposeBag)
        
        output.pageScrollTo
            .bind(to: listPageView.rx.selectedPage)
            .disposed(by: disposeBag)
    }
}
