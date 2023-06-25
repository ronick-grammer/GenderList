//
//  ListPageView+Rx.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import UIKit
import RxSwift

extension Reactive where Base: ListPageView {
    
    /// 페이지 스와이프 Observable
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
    /// 리스트 화면 구성 전환 Binder
    var columnStyle: Binder<ColumnStyle> {
        Binder(self.base) { listPageView, columnStyle in
            listPageView.viewModel.columnStyle = columnStyle
            
            let cell_1 = listPageView.cellForItem(at: IndexPath(row: 0, section: 0)) as? ListPageViewCell
            let cell_2 = listPageView.cellForItem(at: IndexPath(row: 1, section: 0)) as? ListPageViewCell
            
            cell_1?.listView.setColumnStyle(columnStyle: columnStyle)
            cell_2?.listView.setColumnStyle(columnStyle: columnStyle)
        }
    }
    
    
    /// 선택한 페이지로 스크롤 이동 Binder
    var selectedPage: Binder<Int> {
        Binder(self.base) { ListPageView, pageIndex in
            let indexPath = IndexPath(row: pageIndex, section: 0)
            ListPageView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
