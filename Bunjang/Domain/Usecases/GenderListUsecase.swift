//
//  GenderListUsecase.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift


/// 성별 리스트 유즈케이스
protocol GenderListUsecase {
    
    /// 성별 리스트 데이터를 가져옵니다
    /// - Parameter genderListQuery: 쿼리파라미터
    /// - Returns: 성별 리스트 데이터 Observable
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
