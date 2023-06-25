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
        let page = genderListQuery.page
        let results = genderListQuery.results
        let seed = genderListQuery.seed
        
        return networkService
            .request(
                urlString: "https://randomuser.me/api/?page=\(page)&results=\(results)&seed=\(seed)&inc=gender,name,email,picture",
                queryParameter: genderListQuery.parameters
            )
    }
}

