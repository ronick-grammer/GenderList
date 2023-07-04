//
//  PagenationGenerator.swift
//  Bunjang
//
//  Created by Ronick on 6/25/23.
//


/// 페이지네이션 생성 프로토콜
protocol PagenationGenerator {
    associatedtype Element
    associatedtype Fetch
    
    
    /// 현재 페이지네이션 상태
    var fetchStatus: FetchStatus { get set }
    
    
    /// 페이지네이션 기능을 수행합니다
    /// - Parameters:
    ///   - fetch: 데이터 패칭을 실행하는 클로저
    ///   - onCompletion: 데이터 패칭 이후 실행할 클로저
    ///   - onError: 에러 발생 시 실행할 클로저
    mutating func next(fetch: Fetch, onCompletion: ((Element) -> Void)?, onError: ((Error) -> Void)?)
    
    
    /// 페이지네이션 데이터를 초기화 합니다
    mutating func reset()
}
