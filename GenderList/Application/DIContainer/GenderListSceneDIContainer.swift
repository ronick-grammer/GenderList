//
//  GenderListSceneDIContainer.swift
//  GenderList
//
//  Created by RONICK on 2023/07/11.
//

import UIKit

final class GenderListSceneDIContainer: GenderListFlowCoodinatorDependencies {
    func makeGenderDetailsViewController(genderProfileItem: GenderProfileItemViewModel) -> DetailViewController {
        let detailView = DetailView(viewModel: genderProfileItem)
        return DetailViewController(detailView: detailView)
    }
    
    func makeGenderListViewController(showDetailList: (GenderProfileItemViewModel) -> Void) -> GenderListViewController {
        GenderListViewController()
    }
    
    func makeGenderListFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> GenderListFlowCoordinator {
        GenderListFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self
        )
    }
}
