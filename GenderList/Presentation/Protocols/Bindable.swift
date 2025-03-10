//
//  Bindable.swift
//  GenderList
//
//  Created by Ronick on 6/22/23.
//

import UIKit
import RxSwift

/// Rx 이벤트를 바인딩 하는 뷰컨트롤러 전용 프로토콜
protocol Bindable {
    
    associatedtype ViewModel: ViewModelType
    
    /// 비즈니스 로직을 담을 뷰모델
    var viewModel: ViewModel { get }
    
    /// 입력 이벤트
    var input: ViewModel.Input { get }
    
    /// 출력 이벤트
    var output: ViewModel.Output { get }
    
    var disposeBag: DisposeBag { get }
    
    /// 이벤트를 바인딩합니다.
    func bind()
}
