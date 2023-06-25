//
//  ListViewCell.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import SnapKit
import RxSwift

final class ListPageViewCell: UICollectionViewCell {
    
    var listView = ListView()
    
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
    
    func configure(columnStyle: ColumnStyle, tabName: String) {
        listView.configure(columnStyle: columnStyle, tabName: tabName)
    }
    
    func changeColumnStyle(columnStyle: ColumnStyle) {
        listView.setColumnStyle(columnStyle: columnStyle)
    }
    
}
