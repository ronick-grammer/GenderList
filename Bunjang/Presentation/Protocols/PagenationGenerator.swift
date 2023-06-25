//
//  PagenationGenerator.swift
//  Bunjang
//
//  Created by Ronick on 6/25/23.
//

protocol PagenationGenerator {
    associatedtype Element
    associatedtype Fetch
    
    mutating func next(fetch: Fetch, onCompletion: ((Element) -> Void)?)
}
