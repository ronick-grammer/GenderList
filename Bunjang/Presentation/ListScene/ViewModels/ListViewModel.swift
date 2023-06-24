//
//  ListViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

class ListViewModel: ViewModelType {
    
    struct Input {
        let itemSelected: Observable<Int>
    }
    
    struct Output {
        
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
