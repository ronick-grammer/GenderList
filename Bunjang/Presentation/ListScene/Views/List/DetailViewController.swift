//
//  DetailViewController.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    
    let element: ListViewCell
    
    init(element: ListViewCell) {
        self.element = element
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
        view.addSubview(element)
        element.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
