//
//  AppDIContainer.swift
//  GenderList
//
//  Created by RONICK on 2023/07/11.
//

import UIKit

final class AppDIContainer {
    func makeGenderListSceneDIContainer() -> GenderListSceneDIContainer {
        GenderListSceneDIContainer()
    }
    
    func makeGenderListDetailDIContainer(dependencies: GenderListDetailDIContainer.Dependencies) -> GenderListDetailDIContainer {
        GenderListDetailDIContainer(dependencies: dependencies)
    }
}
