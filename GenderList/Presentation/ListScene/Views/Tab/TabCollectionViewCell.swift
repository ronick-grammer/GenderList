//
//  TabViewCell.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit

final class TabCollectionViewCell: UICollectionViewCell {
    private let tabTitleLabel: UILabel = {
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
    
    func setTitle(_ title: String, isFirstTab: Bool) {
        tabTitleLabel.text = title
        backgroundColor = .lightGray
        changeTitleColor(to: isFirstTab ? .black : .gray)
    }
    
    func changeTitleColor(to: UIColor) {
        tabTitleLabel.textColor = to
    }
}
