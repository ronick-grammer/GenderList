//
//  ListViewCell.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit

class ListViewCell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ronick Kim"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "ronick@gmail.com"
        label.font = UIFont.systemFont(ofSize: 13)
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
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom)
            $0.centerX.equalTo(profileImageView)
        }
        
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.centerX.equalTo(profileImageView)
        }
    }
    
    func configure(color: UIColor) {
        backgroundColor = color
    }
}


