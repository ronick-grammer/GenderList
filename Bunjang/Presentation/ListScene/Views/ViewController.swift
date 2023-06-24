//
//  ViewController.swift
//  Bunjang
//
//  Created by Ronick on 6/20/23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

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
        
        navigationController?.navigationBar.topItem?.title = "List"
        
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
        detailVC.navigationController?.navigationBar.topItem?.title = "상세"
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

