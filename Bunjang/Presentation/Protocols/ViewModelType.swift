//
//  ViewModelType.swift
//  Bunjang
//
//  Created by Ronick on 6/22/23.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
