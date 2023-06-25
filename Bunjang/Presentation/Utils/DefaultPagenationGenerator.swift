//
//  DefaultPagenationGenerator.swift
//  Bunjang
//
//  Created by Ronick on 6/25/23.
//

import Foundation

final class DefaultPagenationGenerator<T>: PagenationGenerator {
    
    typealias Element = Array<T>
    
    typealias Fetch = (_ offset: Int, _ limit: Int, _ completion: (_ result: Element) -> Void) -> Void
    
    var offset: Int
    let limit: Int
    
    init(offset: Int, limit: Int = 10) {
        self.offset = offset
        self.limit = limit
    }
    
    func next(fetch: Fetch, onCompletion: ((Element) -> Void)? = nil) {
        fetch(offset, limit) { [weak self] items in
            onCompletion?(items)
            self?.offset += items.count
        }
    }

}
