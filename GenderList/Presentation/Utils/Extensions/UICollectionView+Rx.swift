//
//  UICollectionView+Rx.swift
//  GenderList
//
//  Created by Ronick on 6/25/23.
//

import UIKit
import RxSwift

extension Reactive where Base: UICollectionView {
    /// 스크롤을 밑으로 끝까지 내렸을 경우의 Observable
    var scrolledToBottom: Observable<Void> {
        base.rx.didScroll.flatMap {
            Observable.create { observer -> Disposable in
                let contentOffsetY = base.contentOffset.y
                let contentHeight = base.contentSize.height
                let height = base.frame.height
                
                if contentOffsetY > contentHeight - height {
                    observer.onNext(())
                }
                
                observer.onCompleted()
                
                return Disposables.create()
            }
        }
    }
}
