//
//  GenderListFetchHelper.swift
//  GenderList
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
    typealias Element = GenderProfileItemViewModel
    
    private let pagenationGenerator = DefaultPagenationGenerator<Element>(page: 1, limit: 40)
    private let genderListUsecase: GenderListUsecase
    
    var disposeBag = DisposeBag()
    
    private var seed: String {
        "GenderList"
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
            Task {
                do {
                    let query = GenderListQuery(page: page, results: limit, seed: self.seed)
                    let genderList = try await self.genderListUsecase.get(genderListQuery: query)
                        .filter { $0.gender == genderType }
                    
                    completion(genderList)
                } catch(let e) {
                    error(e)
                }
            }
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
    
    func remove(at indexes: [Int]) -> [Element] {
        pagenationGenerator.remove(indexes: indexes)
    }
}
