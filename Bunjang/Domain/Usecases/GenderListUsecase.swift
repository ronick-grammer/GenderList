//
//  GenderListUsecase.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

protocol GenderListUsecase {
    func get(genderListQuery: GenderListQuery) -> Observable<GenderList>
}

final class DefaultGenderListUsecase: GenderListUsecase {
    private let genderListRepository: GenderListRepository
    
    init(genderListRepository: GenderListRepository) {
        self.genderListRepository = genderListRepository
    }
    
    func get(genderListQuery: GenderListQuery) -> Observable<GenderList> {
        return genderListRepository.getGenderList(genderListQuery: genderListQuery)
    }

}
