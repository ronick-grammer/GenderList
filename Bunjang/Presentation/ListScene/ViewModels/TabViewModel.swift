//
//  TabViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/23/23.
//

import RxSwift

final class TabViewModel: ViewModelType {
    
    struct Input {
        /// 탭 화면(남자, 여자) 리스트 초기화 이벤트
        let tabsInitialized: Observable<[String]>
    }
    
    struct Output {
        /// 탭 타이틀
        let tabs: Observable<[String]>
    }
    
    var pageInfo: PageInfo = (prev: 0, current: 0)
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let tabs = input.tabsInitialized
        
        return Output(tabs: tabs)
    }
}
