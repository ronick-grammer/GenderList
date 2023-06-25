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
    
    var listView: ListView? {
        didSet { setUp() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        guard let listView = listView else {
            return
        }
        
        contentView.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(columnStyle: ColumnStyle, tabName: String) {
        listView = ListView(tab: tabName)
        listView?.configure(columnStyle: columnStyle)
    }
    
    func changeColumnStyle(columnStyle: ColumnStyle) {
        listView?.setColumnStyle(columnStyle: columnStyle)
    }
    
}
