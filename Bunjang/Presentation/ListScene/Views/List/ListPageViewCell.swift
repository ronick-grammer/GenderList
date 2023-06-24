//
//  ListViewCell.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import SnapKit
import RxSwift

class ListPageViewCell: UICollectionViewCell {
    
    let listView = ListView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(color: UIColor, columnStyle: ColumnStyle) {
        backgroundColor = color
        listView.configure(columnStyle: columnStyle)
    }
    
    func changeColumnStyle(columnStyle: ColumnStyle) {
        listView.setColumnStyle(columnStyle: columnStyle)
    }
    
}
