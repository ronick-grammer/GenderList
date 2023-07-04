//
//  GenderListFetchHelper.swift
//  Bunjang
//
//  Created by Ronick on 6/26/23.
//

import RxSwift

protocol GenderListPagenationFetchable {
    associatedtype Element
    
    var disposeBag: DisposeBag { get }
    
    func fetch(genderType: String) -> Observable<[Element]>
}

struct DefaultGenderListFetchHelper: GenderListPagenationFetchable {
    typealias Element = Gender
    
    private let pagenationGenerator = DefaultPagenationGenerator<Element>(page: 1, limit: 40)
    private let genderListUsecase: GenderListUsecase
    
    var disposeBag = DisposeBag()
    
    private var seed: String {
        "Bunjang"
    }
    
    public var fetchStatus: FetchStatus {
        pagenationGenerator.fetchStatus
    }
    
    init(usecase: GenderListUsecase) {
        self.genderListUsecase = usecase
    }
    
    func fetch(genderType: String) -> Observable<[Element]> {
        let result = PublishSubject<[Element]>()
        self.pagenationGenerator.next(fetch: { page, limit, completion, error in
            let query = GenderListQuery(page: page, results: limit, seed: self.seed)
            self.genderListUsecase.get(genderListQuery: query)
                .map { $0.results.filter { genderList in genderList.gender == genderType } }
                .subscribe(
                    onNext: { completion($0) },
                    onError: { error($0) }
                ).disposed(by: self.disposeBag)
        }, onCompletion: {
            result.onNext($0)
        }, onError: {
            result.onError($0)
        })
        
        return result.asObservable()
    }
    
    func reset(genderType: String) -> Observable<[Element]> {
        pagenationGenerator.reset()
        return fetch(genderType: genderType)
    }
}

