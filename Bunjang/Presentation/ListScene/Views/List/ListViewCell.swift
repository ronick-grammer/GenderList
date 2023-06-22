//
//  ListViewCell.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit

class ListViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
    }
    
    func configure(color: UIColor) {
        backgroundColor = color
    }
}


