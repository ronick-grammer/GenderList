//
//  GenderListSceneDIContainer.swift
//  GenderList
//
//  Created by RONICK on 2023/07/11.
//

import UIKit

final class GenderListSceneDIContainer: GenderListFlowCoodinatorDependencies {
    func makeGenderListViewController(showDetailList: @escaping (GenderProfileItemViewModel) -> Void) -> GenderListViewController {
        let viewController = GenderListViewController(showDetailList: showDetailList)
        viewController.reactor = GenderListViewReactor()
        
        return viewController
    }
    
    func makeGenderListFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> GenderListFlowCoordinator {
        GenderListFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self
        )
    }
}
