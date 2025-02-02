//
//  ListCollectionViewCell.swift
//  GenderList
//
//  Created by Ronick on 6/21/23.
//

import UIKit
import Kingfisher

final class ListCollectionViewCell: UICollectionViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ronick Kim"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "ronick@gmail.com"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        
        return label
    }()
    
    private let checkImage: UIImageView = {
        let imageView = UIImageView()
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        imageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: configuration)
        
        return imageView
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
            $0.centerX.top.equalToSuperview()
            $0.height.equalTo(125)
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
        
        contentView.addSubview(checkImage)
        checkImage.snp.makeConstraints {
            $0.top.trailing.equalTo(profileImageView)
        }
        
        checkImage.isHidden = true
    }
    
    func configure(profileItem: GenderProfileItemViewModel, isSelected: Bool) {
        let profileImageUrl = URL(string: profileItem.profileUrl)
        
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: profileImageUrl)
        nameLabel.text = profileItem.name
        emailLabel.text = profileItem.email
        
        checkImage.isHidden = !isSelected
    }
    
    func itemTapped() {
        checkImage.isHidden = !checkImage.isHidden
    }
}


