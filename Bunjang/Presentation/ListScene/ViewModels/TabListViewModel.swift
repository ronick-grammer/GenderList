//
//  TabListViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/23/23.
//

import RxSwift

final class TabListViewModel: ViewModelType {
    
    struct Input {
        let columnStyleButtonTapped: Observable<Void>
        let tabButtonTapped: Observable<PageInfo>
        let pageSwiped: Observable<PageInfo>
    }
    
    struct Output {
        let columnStyle: Observable<ColumnStyle>
        let selectedTab: Observable<PageInfo>
        let pageScrollTo: Observable<Int>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let columnStyle = input.columnStyleButtonTapped
            .scan(ColumnStyle.two) { prev, _ in
                switch prev {
                case .one: return .two
                case .two: return .one
                }
            }
        
        let selectedTab = input.pageSwiped
        
        let pageScrollTo = input.tabButtonTapped
            .map { $0.current }
        
        return Output(
            columnStyle: columnStyle,
            selectedTab: selectedTab,
            pageScrollTo: pageScrollTo
        )
    }
}
