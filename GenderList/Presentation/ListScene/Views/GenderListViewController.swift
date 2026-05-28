//
//  GenderListViewController.swift
//  GenderList
//
//  Created by Ronick on 6/20/23.
//

import UIKit
import SnapKit
import RxSwift
import ReactorKit

final class GenderListViewController: BaseViewController {
    typealias Reactor = GenderListViewReactor
    
    private let showDetailList: (GenderProfileItemViewModel) -> Void
    
    private lazy var selectBarButton: UIBarButtonItem = {
        UIBarButtonItem(title: "선택", style: .plain, target: self, action: nil)
    }()
    
    private lazy var removeBarButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold, scale: .large)
        let image = UIImage(systemName: "trash", withConfiguration: configuration)
        return UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
    }()
    
    private let listCollectionView = ListCollectionView()
    
    private let columnStyleButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: "square.grid.2x2", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    init(showDetailList: @escaping (GenderProfileItemViewModel) -> Void) {
        self.showDetailList = showDetailList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        navigationController?.navigationBar.topItem?.title = "Gender List"
        navigationItem.rightBarButtonItems = [selectBarButton, removeBarButton]
        
        view.addSubview(listCollectionView)
        view.addSubview(columnStyleButton)
    }
    
    override func setupConstraints() {
        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        columnStyleButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

extension GenderListViewController: ReactorKit.View {
    func bind(reactor: GenderListViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        selectBarButton.rx.tap
            .map { Reactor.Action.toggleSelectMode }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        removeBarButton.rx.tap
            .map { Reactor.Action.removeSelected }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        columnStyleButton.rx.tap
            .map { Reactor.Action.toggleColumnStyle }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        listCollectionView.itemTapped
            .map { Reactor.Action.selectItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        listCollectionView.scrolledToBottom
            .map { Reactor.Action.scrollToBottom }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        listCollectionView.pullToRefresh
            .map { Reactor.Action.pullToRefresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 초기 fetch 트리거 — 1회성
        reactor.state.take(1)
            .map { _ in Reactor.Action.configure }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map { $0.selectButtonTitle }
            .distinctUntilChanged()
            .bind(to: selectBarButton.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.columnStyle }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.listCollectionView.updateColumnStyle($0) })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.listSnapshot }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.listCollectionView.applySnapshot($0) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$moveToDetail)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.showDetailList($0) })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.view.makeToast("리스트를 불러오는데 실패하였습니다. 다시 시도해 주세요", withDuration: 2, delay: 1.5)
            })
            .disposed(by: disposeBag)
    }
}
