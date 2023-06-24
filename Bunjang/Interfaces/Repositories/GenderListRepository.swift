//
//  GenderListRepository.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

protocol GenderListRepository {
    func getGenderList(genderListQuery: GenderListQuery) -> Observable<Result<GenderList, Error>>
}