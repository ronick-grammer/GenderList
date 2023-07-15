//
//  AppFlowCoordinator.swift
//  GenderList
//
//  Created by RONICK on 2023/07/11.
//

import UIKit

final class AppFlowCoordinator {
    let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let genderListSceneDIContainer = appDIContainer.makeGenderListSceneDIContainer()
        let flow = genderListSceneDIContainer.makeGenderListFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        flow.start()
    }
    
    func startDetailsView(dependencies: GenderListDetailDIContainer.Dependencies) {
        let genderListDetailDIContainer = appDIContainer.makeGenderListDetailDIContainer(
            dependencies: dependencies
        )
        let flow = genderListDetailDIContainer.makeGenderListDetailFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: self
        )
        flow.start()
    }
}
