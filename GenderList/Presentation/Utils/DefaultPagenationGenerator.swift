//
//  DefaultPagenationGenerator.swift
//  GenderList
//
//  Created by Ronick on 6/25/23.
//

import Foundation

final class DefaultPagenationGenerator<T>: PagenationGenerator {
    
    typealias Element = Array<T>
    
    typealias Fetch = (
        _ page: Int,
        _ limit: Int,
        _ completion: @escaping (_ result: Element) -> Void,
        _ error: @escaping (_ error: Error) -> Void
    ) -> Void
    
    var page: Int
    let limit: Int
    
    private var elements: Element = []
    
    public var fetchStatus: FetchStatus = .ready
    
    init(page: Int, limit: Int) {
        self.page = page
        self.limit = limit
    }
    
    func next(fetch: Fetch, onCompletion: ((Element) -> Void)? = nil, onError: ((Error) -> Void)? = nil) {
        fetchStatus = .loading
        
        fetch(page, limit, { [weak self] items in
            guard let self = self else { return }
            self.fetchStatus = .ready
            self.elements.append(contentsOf: items)
            self.page += 1
            onCompletion?(self.elements)
        }, { error in
            onError?(error)
        })
    }
    
    func reset() {
        page = 1
        self.elements.removeAll()
    }
    
    func remove(indexes: [Int]) -> Element {
        elements = elements
            .enumerated()
            .filter { !indexes.contains($0.offset) }
            .map { $0.element }
        
        return elements
    }
}
