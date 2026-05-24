//
//  ListPageCollectionViewCell.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import SnapKit

final class PageCollectionViewCell: UICollectionViewCell {
    private weak var currentListView: ListCollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(listView: ListCollectionView) {
        guard currentListView !== listView else { return }
        
        currentListView?.removeFromSuperview()
        contentView.addSubview(listView)
        
        listView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
        
        currentListView = listView
    }
}
