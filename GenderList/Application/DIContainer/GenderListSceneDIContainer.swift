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
    
    func makeGenderListViewController() -> GenderListViewController {
        GenderListViewController()
    }
    
    func makeGenderListFlowCoordinator(navigationController: UINavigationController) -> GenderListFlowCoordinator {
        GenderListFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
