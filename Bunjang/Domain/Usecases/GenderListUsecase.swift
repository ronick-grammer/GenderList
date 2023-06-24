//
//  GenderListUsecase.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

protocol GenderListUsecase {
    func get(genderListQuery: GenderListQuery) -> Observable<Result<GenderList, Error>>
}

final class DefaultGenderListUsecase: GenderListUsecase {
    let genderListRepository: GenderListRepository
    
    init(genderListRepository: GenderListRepository) {
        self.genderListRepository = genderListRepository
    }
    
    func get(genderListQuery: GenderListQuery) -> Observable<Result<GenderList, Error>> {
        genderListRepository.getGenderList(genderListQuery: genderListQuery)
    }

}
