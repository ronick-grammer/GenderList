//
//  GenderProfileItemViewModel.swift
//  GenderList
//
//  Created by RONICK on 2023/07/11.
//

import Foundation

struct GenderProfileItemViewModel {
    let gender: String
    let name: String
    let email: String
    let profileUrl: String
}

extension GenderProfileItemViewModel {
    init(genderProfile: GenderProfile) {
        self.gender = genderProfile.gender
        self.name = genderProfile.name
        self.email = genderProfile.email
        self.profileUrl = genderProfile.profileUrl
    }
}
