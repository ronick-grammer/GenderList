//
//  DefaultGenderListRepository.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

import RxSwift

final class DefaultGenderListRepository {
    private let networkService: NetworkService
    
    init(service: NetworkService) {
        networkService = service
    }
}

extension DefaultGenderListRepository: GenderListRepository {
    func getGenderList(genderListQuery: GenderListQuery) -> Observable<GenderList> {
        return networkService
            .request(
                urlString: "https://randomuser.me/api/?gender=male&results=3&inc=name,email,picture",
                queryParameter: genderListQuery.parameters
            )
    }
}

