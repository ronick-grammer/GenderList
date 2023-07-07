//
//  ViewModelType.swift
//  GenderList
//
//  Created by Ronick on 6/22/23.
//

import Foundation
import RxSwift


/// 뷰모델에서 Input Output 디자인 패턴을 사용하도록 강제하는 프로토콜
protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    /// UI 이벤트가 들어오면 이를 가공한 데이터를 방출합니다
    /// - Parameter input: 들어오는 UI 이벤트들
    /// - Returns: 가공된 데이터
    func transform(input: Input) -> Output
}
