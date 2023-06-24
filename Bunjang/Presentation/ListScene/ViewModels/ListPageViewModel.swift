//
//  ListPageViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/22/23.
//

import RxSwift

class ListPageViewModel: ViewModelType {
    
    struct Input {
        let optionButtonTapped: Observable<Void>
    }
    
    struct Output {
        let columnStyle: Observable<ColumnStyle>
    }
    
    var pageInfo: PageInfo = (prev: 0, current: 0)
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let columnStyle = input.optionButtonTapped
            .scan(ColumnStyle.two) { prev, _ in
                switch prev {
                case .one: return .two
                case .two: return .one
                }
            }
        return Output(
            columnStyle: columnStyle
        )
    }
    
}
