//
//  TabViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/23/23.
//

import RxSwift

class TabViewModel: ViewModelType {
    
    struct Input {
        let tabsInitialized: Observable<[String]>
    }
    
    struct Output {
        let tabs: Observable<[String]>
    }
    
    var pageInfo: PageInfo = (prev: 0, current: 0)
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let tabs = input.tabsInitialized
        
        return Output(tabs: tabs)
    }
}
