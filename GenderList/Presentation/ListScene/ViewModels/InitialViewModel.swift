//
//  InitialViewModel.swift
//  GenderList
//
//  Created by RONICK on 2023/07/05.
//

import Foundation
import RxSwift

class InitialViewModel: ViewModelType {
    struct Input {
        let selectButtonTapped: Observable<Void>
    }
    
    struct Output {
        let selectButtonTitle: Observable<String>
    }
    
    struct Actions {
        let showDetails: (GenderProfileItemViewModel) -> Void
    }
    
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let selectButtonTitle = input.selectButtonTapped
            .scan(true) { prev, _ in
                !prev
            }.map { $0 ? "선택" : "취소" }
        
        return Output(selectButtonTitle: selectButtonTitle)
    }
}
