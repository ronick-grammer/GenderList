//
//  ListViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

final class ListViewModel: ViewModelType {
    
    struct Input {
        let tabInitialized: PublishSubject<String>
        let scrolledToBottom: Observable<Void>
        let didPullToRefresh: PublishSubject<Void>
    }
    
    struct Output {
        let genderList: BehaviorSubject<[Gender]>
    }
    
    var disposeBag = DisposeBag()
        
    private let fetchHelper: DefaultGenderListFetchHelper
    
    init(usecase: GenderListUsecase = DefaultGenderListUsecase(
        genderListRepository: DefaultGenderListRepository(service: DefaultNetworkService()))
    ) {
        self.fetchHelper = DefaultGenderListFetchHelper(usecase: usecase)
    }
    
    func transform(input: Input) -> Output {
        
        let genderList = BehaviorSubject<[Gender]>.init(value: [])
        
        var genderType = ""
        input.tabInitialized
            .subscribe(onNext: { gender in
                genderType = gender
                self.fetchHelper.fetch(genderType: genderType, genderList: genderList)
            }).disposed(by: disposeBag)
        
        input.scrolledToBottom
            .filter { self.fetchHelper.fetchStatus == .ready }
            .subscribe(onNext: {
                self.fetchHelper.fetch(genderType: genderType, genderList: genderList)
            }).disposed(by: disposeBag)
        
        input.didPullToRefresh
            .subscribe(onNext: {
                self.fetchHelper.reset(genderType: genderType, genderList: genderList)
            }).disposed(by: disposeBag)
            
        
        return Output(
            genderList: genderList
        )
    }
}
