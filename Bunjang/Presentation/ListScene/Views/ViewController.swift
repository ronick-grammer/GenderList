//
//  ViewController.swift
//  Bunjang
//
//  Created by Ronick on 6/20/23.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

    var tabListView =  TabListView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.title = "Gender List"
        
        tabListView.setListViewDelegate(listViewDelegate: self)
        setUp()
    }
    
    private func setUp() {
        view.addSubview(tabListView)
        
        tabListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ViewController: ListViewDelegate {
    func pushDetailViewController(detailVC: DetailViewController) {
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

