//
//  NetworkService.swift
//  GenderList
//
//  Created by Ronick on 6/24/23.
//

import RxSwift
import Alamofire

protocol NetworkService {
    func request<T: Decodable, E>(urlString: String, queryParameter: E?) async throws -> T
    func request<T: Decodable, E: Encodable>(urlString: String, parameter: E) async throws -> T
}

final class DefaultNetworkService: NetworkService {
    func request<T: Decodable, E>(urlString: String, queryParameter: E?) async throws -> T {
        return try await AF
            .request(urlString,
                     method: .get,
                     encoding: URLEncoding.queryString)
            .serializingDecodable(T.self)
            .value
    }
    
    func request<T: Decodable, E: Encodable>(urlString: String, parameter: E) async throws -> T {
        return try await AF
            .request(urlString,
                     method: .post,
                     parameters: parameter,
                     encoder: JSONParameterEncoder.default)
            .serializingDecodable(T.self)
            .value
    }
}
