//
//  TabViewCell.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit

class TabViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        
    }
    
    func configure(color: UIColor) {
        backgroundColor = color
    }
}

