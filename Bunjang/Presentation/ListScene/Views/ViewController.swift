//
//  ViewController.swift
//  Bunjang
//
//  Created by Ronick on 6/20/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let listContainerView = ListContainerView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.title = "List"
        
        setUp()
    }
    
    private func setUp() {
        view.addSubview(listContainerView)
        
        listContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

