//
//  TabViewCell.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit

class TabViewCell: UICollectionViewCell {
    
    let tabTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(tabTitleLabel)
        tabTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setTitle(_ title: String) {
        tabTitleLabel.text = title
    }
}

