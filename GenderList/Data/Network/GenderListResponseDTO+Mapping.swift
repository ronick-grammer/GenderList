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

extension GenderList {
    func toDomain() -> [GenderProfile] {
        results.map {
            GenderProfile(
                gender: $0.gender,
                name: $0.name.first + " " + $0.name.last,
                email: $0.email,
                profileUrl: $0.picture.large
            )
        }
    }
}
