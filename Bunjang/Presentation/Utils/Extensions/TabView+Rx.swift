//
//  TabView+Rx.swift
//  Bunjang
//
//  Created by Ronick on 6/26/23.
//

import UIKit
import RxSwift

extension Reactive where Base: TabView {
    var tabButtonTapped: Observable<PageInfo> {
        base.rx.itemSelected
            .map {
                let currentPage = $0.row
                let previousPage = base.viewModel.pageInfo.prev
                
                if base.viewModel.pageInfo.current != currentPage {
                    base.viewModel.pageInfo.prev = base.viewModel.pageInfo.current
                    base.viewModel.pageInfo.current = currentPage
                }
                
                return (prev: previousPage, current: currentPage)
            }
    }
    
    var selectedTab: Binder<PageInfo> {
        Binder(self.base) { tabView, pageInfo in
            let prevCell = tabView.cellForItem(at: IndexPath(row: pageInfo.prev, section: 0)) as? TabViewCell
            prevCell?.changeTitleColor(to: .gray)
            
            let currentCell = tabView.cellForItem(at: IndexPath(row: pageInfo.current, section: 0)) as? TabViewCell
            currentCell?.changeTitleColor(to: .black)
        }
    }
}
