//
//  TabViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/23/23.
//

import RxSwift

class TabViewModel: ViewModelType {
    
    struct Input {
        let pageSwiped: Observable<PageInfo>
    }
    
    struct Output {
        
    }
    
    var pageInfo: PageInfo = (prev: 0, current: 0)
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
