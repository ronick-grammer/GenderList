//
//  NetworkService.swift
//  GenderList
//
//  Created by Ronick on 6/24/23.
//

import RxSwift
import Alamofire

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
}

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
    
    private func decode<T: Decodable>(data: Data?) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.parsing(error))
        }
    }
}
