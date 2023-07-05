//
//  ListViewModel.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

final class ListViewModel: ViewModelType {
    
    struct Input {
        /// 탭 화면(남자 or 여자) 리스트 초기화 이벤트
        let tabInitialized: PublishSubject<String>
        
        /// 스크롤을 맨 밑으로 내렸을 때 발생하는 이벤트
        let scrolledToBottom: Observable<Void>
        
        /// 새로고침 이벤트
        let didPullToRefresh: PublishSubject<Void>
    }
    
    struct Output {
        /// 성별 리스트
        let genderList: BehaviorSubject<[Gender]>
        
        /// 성별 리스트 에러
        let genderListError: Observable<String>
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
        let genderListError = PublishSubject<String>()
        
        var genderType = ""
        
        input.tabInitialized
            .flatMap {
                genderType = $0
                return self.fetchHelper.fetch(genderType: $0)
            }.subscribe(onNext: { list in
                genderList.onNext(list)
            }, onError: {
                genderListError.onNext($0.localizedDescription)
            }).disposed(by: disposeBag)
        
        input.scrolledToBottom
            .filter { self.fetchHelper.fetchStatus == .ready }
            .flatMap { self.fetchHelper.fetch(genderType: genderType) }
            .subscribe(onNext: { list in
                genderList.onNext(list)
            }, onError: {
                genderListError.onNext($0.localizedDescription)
            }).disposed(by: disposeBag)
        
        input.didPullToRefresh
            .flatMap { self.fetchHelper.reset(genderType: genderType) }
            .subscribe(onNext: { list in
                genderList.onNext(list)
            }, onError: {
                genderListError.onNext($0.localizedDescription)
            }).disposed(by: disposeBag)
        
        return Output(
            genderList: genderList,
            genderListError: genderListError
        )
    }
}
