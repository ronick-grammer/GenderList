//
//  GenderList.swift
//  GenderList
//
//  Created by Ronick on 6/24/23.
//

struct GenderList: Decodable {
    let results: [Gender]
}

struct Gender: Decodable {
    let gender: String
    let name: Name
    let email: String
    let picture: Picture
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

struct Picture: Decodable {
    let large: String
    let medium: String
    let thumbnail: String
}
