//
//  GenderListDetailDIContainer.swift
//  GenderList
//
//  Created by RONICK on 2023/07/13.
//

import UIKit

final class GenderListDetailDIContainer: GenderListDetailFlowCoodinatorDependencies {
    struct Dependencies {
        let genderProfileItem: GenderProfileItemViewModel
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeGenderListDetailViewController() -> DetailViewController {
        let detailView = DetailView(viewModel: dependencies.genderProfileItem)
        return DetailViewController(detailView: detailView)
    }
    
    func makeGenderListDetailFlowCoordinator(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator) -> GenderListDetailFlowCoordinator {
        GenderListDetailFlowCoordinator(
            navigationController: navigationController,
            parentCoordinator: parentCoordinator,
            dependencies: self
        )
    }
}
