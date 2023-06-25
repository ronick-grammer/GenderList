//
//  DetailViewController.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    private let detailView: DetailView
    
    init(detailView: DetailView) {
        self.detailView = detailView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setUp()
    }
    
    private func setUp() {
        view.addSubview(detailView)
        detailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
}
