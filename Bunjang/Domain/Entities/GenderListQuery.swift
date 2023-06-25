//
//  GenderListQuery.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

struct GenderListQuery {
    let page: Int
    
    let results: Int
    
    let seed: String
    
    var parameters: [String: Any] {
        return [
            "page": page,
            "results": results,
            "seed": seed
        ]
    }
}
