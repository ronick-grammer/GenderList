//
//  NetworkService.swift
//  Bunjang
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
    func request<T: Decodable, E>(urlString: String, queryParameter: E?) -> Observable<Result<T, DataTransferError>>
    func request<T: Decodable, E: Encodable>(urlString: String, parameter: E) -> Observable<Result<T, DataTransferError>>
}

final class DefaultNetworkService: NetworkService {
    
    func request<T: Decodable, E>(urlString: String, queryParameter: E?) -> Observable<Result<T, DataTransferError>> {
        
        return Observable<Result<T, DataTransferError>>.create { (observer) -> Disposable in
            AF.request(urlString,
                       method: .get,
                       parameters: queryParameter as? Parameters,
                       encoding: URLEncoding.queryString)
                .response { response in
                    switch response.result {
                    case let .success(data):
                        let result: Result<T, DataTransferError> = self.decode(data: data)
                        observer.onNext(result)
                        observer.onCompleted()
                    case let .failure(error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func request<T: Decodable, E: Encodable>(urlString: String, parameter: E) -> Observable<Result<T, DataTransferError>> {
        return Observable<Result<T, DataTransferError>>.create { (observer) -> Disposable in
            AF.request(urlString,
                       method: .post,
                       parameters: parameter,
                       encoder: JSONParameterEncoder.default)
            .response { response in
                switch response.result {
                case let .success(data):
                    let result: Result<T, DataTransferError> = self.decode(data: data)
                    observer.onNext(result)
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
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

