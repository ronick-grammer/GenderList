//
//  DetailView.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import UIKit

class DetailView: UIView {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
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
    
    private var leadingSpace: Int {
        10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(500)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.equalTo(profileImageView).offset(leadingSpace)
        }
        
        addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(profileImageView).offset(leadingSpace)
        }
    }
    
    func configure(genderInfo: Gender) {
        let profileImageUrl = URL(string: genderInfo.picture.large)
        profileImageView.kf.setImage(with: profileImageUrl)
        nameLabel.text = genderInfo.name.first + genderInfo.name.last
        emailLabel.text = genderInfo.email
    }
}
