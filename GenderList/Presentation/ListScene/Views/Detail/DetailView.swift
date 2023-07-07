//
//  DetailView.swift
//  GenderList
//
//  Created by Ronick on 6/24/23.
//

import UIKit

final class DetailView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        return scrollView
    }()
    
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
        scrollView.delegate = self
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
            $0.height.equalTo(500)
        }
        
        scrollView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(scrollView)
            $0.height.equalTo(scrollView)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.bottom).offset(20)
            $0.leading.equalTo(scrollView).offset(leadingSpace)
        }
        
        addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalTo(scrollView).offset(leadingSpace)
        }
    }
    
    func configure(genderInfo: Gender?) {
        guard let genderInfo = genderInfo else { return }
        
        let profileImageUrl = URL(string: genderInfo.picture.large)
        profileImageView.kf.setImage(with: profileImageUrl)
        nameLabel.text = genderInfo.name.first + genderInfo.name.last
        emailLabel.text = genderInfo.email
    }
}

extension DetailView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return profileImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < scrollView.minimumZoomScale {
            scrollView.zoomScale = scrollView.minimumZoomScale
        }
    }
}
