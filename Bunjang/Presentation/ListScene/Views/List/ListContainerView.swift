//
//  ListContainerView.swift
//  Bunjang
//
//  Created by Ronick on 6/21/23.
//

import UIKit

class ListContainerView: UIView {
    
    let tabView = TabView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let listView: ListPageView = ListPageView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let optionButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .large)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        
        button.setImage(image, for: .normal)
        
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubview(tabView)
        tabView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        addSubview(listView)
        listView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(tabView.snp.bottom).offset(30)
        }
        
        addSubview(optionButton)
        optionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
