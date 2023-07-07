//
//  InitialViewController.swift
//  Bunjang
//
//  Created by Ronick on 6/20/23.
//

import UIKit
import SnapKit
import RxSwift

final class InitialViewController: UIViewController {

    lazy var tabListView =  TabPageView(
        selectBarButtonTapped: selectBarButton.rx.tap
            .scan(false, accumulator: { prev, _ in
                !prev
            }).share(replay: 1),
        removeBarButtonTapped: removeBarButton.rx.tap.asObservable()
    )
    
    lazy var selectBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(
            title: "선택",
            style: .plain,
            target: self,
            action: nil)
        
        return barButton
    }()
    
    lazy var removeBarButton: UIBarButtonItem = {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 15,
            weight: .bold,
            scale: .large
        )
        let image = UIImage(systemName: "trash", withConfiguration: configuration)
        let barButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: nil
        )
        
        return barButton
    }()
    
    typealias ViewModel = InitialViewModel
    
    let viewModel = ViewModel()
    
    lazy var input = ViewModel.Input(
        selectButtonTapped: selectBarButton.rx.tap.asObservable()
    )
    
    lazy var output = viewModel.transform(input: input)
    
    var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.title = "Gender List"
        navigationItem.rightBarButtonItems = [selectBarButton, removeBarButton]
        
        tabListView.setListViewDelegate(listViewDelegate: self)
        setUp()
        bind()
    }
    
    private func setUp() {
        view.addSubview(tabListView)
        
        tabListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension InitialViewController: Bindable {
    func bind() {
        output.selectButtonTitle
            .bind(to: selectBarButton.rx.title)
            .disposed(by: disposeBag)
    }
}

extension InitialViewController: ListViewDelegate {
    func pushDetailViewController(detailVC: DetailViewController) {
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

