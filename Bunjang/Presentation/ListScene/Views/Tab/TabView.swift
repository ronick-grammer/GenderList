//
//  TabView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

class TabView: UICollectionView {
    
    let cellIdentifier = "TabViewCell"
    
    var disposeBag = DisposeBag()
    
    private let colorEvent = PublishSubject<[UIColor]>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setUp()
        bind()
        
        colorEvent.onNext(colors)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
        
        register(TabViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    
}

extension TabView {
    func bind() {
        colorEvent
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: TabViewCell.self))
        { index, item, cell in
            cell.configure(color: item)
        }.disposed(by: disposeBag)
        
        rx.itemSelected
            .bind { indexPath in
                print(indexPath.row)
            }.disposed(by: disposeBag)
    }
}


let colors: [UIColor] = [
    .gray,
    .red
]
