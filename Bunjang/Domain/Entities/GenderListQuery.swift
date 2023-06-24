//
//  GenderListQuery.swift
//  Bunjang
//
//  Created by Ronick on 6/24/23.
//

struct GenderListQuery {
    let gender: String
    
    var parameters: [String: Any] {
        return ["gender": gender]
    }
}
