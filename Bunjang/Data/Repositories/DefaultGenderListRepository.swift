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
    func getGenderList(genderListQuery: GenderListQuery) -> Observable<Result<GenderList, Error>> {
        let result: Observable<Result<GenderList, DataTransferError>> = networkService
            .request(urlString: "https://randomuser.me/api/", queryParameter: genderListQuery.parameters)
        
        return result.map { result -> Result<GenderList, Error> in
            switch result {
            case .success(let genderList):
                return .success(genderList)
            case .failure(let error):
                return .failure(error)
            }
            
        }
    }
}

