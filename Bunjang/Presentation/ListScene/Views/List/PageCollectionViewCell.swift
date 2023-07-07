//
//  ListPageCollectionViewCell.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import SnapKit
import RxSwift

final class PageCollectionViewCell: UICollectionViewCell {
    
    var listCollectionView = ListCollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(listCollectionView)
        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(columnStyle: ColumnStyle, tabName: String) {
        listCollectionView.configure(columnStyle: columnStyle, tabName: tabName)
    }
    
    func setListViewDelegate(listViewDelegate: ListViewDelegate?) {
        listCollectionView.setListViewDelegate(listViewDelegate: listViewDelegate)
    }
    
    func setSelectButtonTapped(selectButtonTapped: Observable<Bool>) {
        listCollectionView.setSelectButtonTapped(selectButtonTapped: selectButtonTapped)
    }
    
    func setRemoveBarButtonTapped(removeBarButtonTapped: Observable<Void>) {
        listCollectionView.setRemoveBarButtonTapped(removeBarButtonTapped: removeBarButtonTapped)
    }
    
}
