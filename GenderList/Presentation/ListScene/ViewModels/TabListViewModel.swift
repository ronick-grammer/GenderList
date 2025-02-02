//
//  TabListViewModel.swift
//  GenderList
//
//  Created by Ronick on 6/23/23.
//

import RxSwift

final class TabListViewModel: ViewModelType {
    struct Input {
        /// 성별 리스트 구성 전환 버튼 클릭 이벤트
        let columnStyleButtonTapped: Observable<Void>
        
        /// 성별 탭(남자 or 여자) 버튼 클릭 이벤트
        let tabButtonTapped: Observable<PageInfo>
        
        /// 탭 화면 스와이프 이벤트
        let pageSwiped: Observable<PageInfo>
    }
    
    struct Output {
        /// 성별 리스트 구성 전환 타입
        let columnStyle: Observable<ColumnStyle>
        
        /// 선택된 탭(남자 or 여자)
        let selectedTab: Observable<PageInfo>
        
        /// 전환될 탭 페이지(화면 - 남자 탭화면 or 여자 탭화면)
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
