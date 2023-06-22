//
//  ListView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift

class ListView: UICollectionView {
    
    let cellIdentifier = "ListViewCell"
    
    let colorEvent = PublishSubject<[UIColor]>()
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUp()
        bind()
        colorEvent.onNext(listViewColor)
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
}

extension ListView {
    func bind() {
        colorEvent
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: ListViewCell.self))
        { index, item, cell in
            cell.configure(color: item)
        }.disposed(by: disposeBag)
    }
}



let listViewColor: [UIColor] = [
    .black,
    .blue,
    .brown,
    .cyan,
    .gray,
    .orange,
    .yellow,
    .systemPink,
    .red
]
