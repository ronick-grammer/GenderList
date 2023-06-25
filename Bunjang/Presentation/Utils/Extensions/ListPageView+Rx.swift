//
//  ListPageView+Rx.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import UIKit
import RxSwift

extension Reactive where Base: ListPageView {
    var pageSwiped: Observable<PageInfo> {
        base.rx.didScroll
            .map {
                let currentPage = base.visibleIndexPath?.row ?? 0
                let previousPage = base.viewModel.pageInfo.prev
                
                if base.viewModel.pageInfo.current != currentPage {
                    base.viewModel.pageInfo.prev = base.viewModel.pageInfo.current
                    base.viewModel.pageInfo.current = currentPage
                }
                
                return (prev: previousPage, current: currentPage)
            }
    }
    
    //TODO: 수정 필요
    var columnStyle: Binder<ColumnStyle> {
        Binder(self.base) { listPageView, columnStyle in
            listPageView.columnStyle = columnStyle
            
            let cell_1 = listPageView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ListPageViewCell
            let cell_2 = listPageView.cellForItem(at: IndexPath(row: 1, section: 0)) as? ListPageViewCell
            
            cell_1?.listView?.setColumnStyle(columnStyle: columnStyle)
            cell_2?.listView?.setColumnStyle(columnStyle: columnStyle)
        }
    }
    
    var selectedPage: Binder<Int> {
        Binder(self.base) { ListPageView, pageIndex in
            let indexPath = IndexPath(row: pageIndex, section: 0)
            ListPageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
