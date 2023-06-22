//
//  ListPageView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import RxSwift
import RxCocoa

class ListPageView: UICollectionView {
    
    let cellIdentifier = "ListPageViewCell"
    
    let colorEvent = PublishSubject<[UIColor]>()
    
    var disposeBag = DisposeBag()
    
    let optionButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUp()
        bind()
        
        colorEvent.onNext(colors)
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
        
        register(ListPageViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        setUpLayout()
    }
    
    private func setUpLayout() {
        
        
//        addSubview(optionButton)
//        optionButton.snp.makeConstraints {
//            $0.width.height.equalTo(50)
//            $0.centerX.equalToSuperview()
//            $0.bottom.equalToSuperview().offset(630)
//        }
    }
}

extension ListPageView {
    func bind() {
        colorEvent
            .bind(to: rx.items(cellIdentifier: cellIdentifier, cellType: ListPageViewCell.self))
        { index, item, cell in
            cell.configure(color: item)
        }.disposed(by: disposeBag)
    }
}

extension ListPageView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIWindow().screen.bounds.width, height: bounds.height)
    }
}

