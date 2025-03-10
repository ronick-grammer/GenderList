//
//  DefaultGenderListRepository.swift
//  GenderList
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
    func getGenderList(genderListQuery: GenderListQuery) async throws -> [GenderProfile] {
        let page = genderListQuery.page
        let results = genderListQuery.results
        let seed = genderListQuery.seed
        
        // TODO: endpoint enum화 작업
        let response: GenderList = try await networkService
            .request(
                urlString: "https://randomuser.me/api/?page=\(page)&results=\(results)&seed=\(seed)&inc=gender,name,email,picture",
                queryParameter: genderListQuery.parameters
            )
        
        return response.toDomain()
    }
}
