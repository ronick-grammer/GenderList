//
//  ListViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

class ListViewModel: ViewModelType {
    
    struct Input {
        let tabInitialized: Observable<String>
    }
    
    struct Output {
        let genderList: Observable<[Gender]>
    }
    
    var disposeBag = DisposeBag()
    
    private let genderListUsecase: GenderListUsecase
    
    init(usecase: GenderListUsecase = DefaultGenderListUsecase(
        genderListRepository: DefaultGenderListRepository(service: DefaultNetworkService()))
    ) {
        self.genderListUsecase = usecase
    }
    
    func transform(input: Input) -> Output {
        
        let genderList = input.tabInitialized
            .flatMap { gender -> Observable<[Gender]> in
                let query = GenderListQuery(gender: gender)
                return self.genderListUsecase.get(genderListQuery: query)
                        .map { $0.results }
            }
        
        return Output(
            genderList: genderList
        )
    }
}
