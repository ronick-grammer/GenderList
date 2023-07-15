//
//  GenderListFlowCoordinator.swift
//  GenderList
//
//  Created by RONICK on 2023/07/11.
//

import UIKit

protocol GenderListFlowCoodinatorDependencies {
    func makeGenderListViewController(showDetailList: (GenderProfileItemViewModel) -> Void) -> GenderListViewController
    func makeGenderDetailsViewController(genderProfileItem: GenderProfileItemViewModel) -> DetailViewController
}

final class GenderListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var parentCoordinator: AppFlowCoordinator?
    
    private let dependencies: GenderListFlowCoodinatorDependencies
    
    private weak var GenderListVC: GenderListViewController?
    
    init(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator, dependencies: GenderListFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeGenderListViewController(showDetailList: showDetailList)
        navigationController?.pushViewController(vc, animated: true)
        GenderListVC = vc
    }
    
    private func showDetailList(genderProfileItem: GenderProfileItemViewModel) {
        parentCoordinator?.startDetailsView(
            dependencies: GenderListDetailDIContainer.Dependencies(
                genderProfileItem: genderProfileItem
            )
        )
    }
}
