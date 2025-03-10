//
//  TabView+Rx.swift
//  GenderList
//
//  Created by Ronick on 6/26/23.
//

import UIKit
import RxSwift

extension Reactive where Base: TabCollectionView {
    /// 탭 버튼 클릭 Observable
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
    
    /// 탭 버튼 선택 처리 Binder
    var selectedTab: Binder<PageInfo> {
        Binder(self.base) { tabView, pageInfo in
            let prevCell = tabView.cellForItem(at: IndexPath(row: pageInfo.prev, section: 0)) as? TabCollectionViewCell
            prevCell?.changeTitleColor(to: .gray)
            
            let currentCell = tabView.cellForItem(at: IndexPath(row: pageInfo.current, section: 0)) as? TabCollectionViewCell
            currentCell?.changeTitleColor(to: .black)
        }
    }
}
