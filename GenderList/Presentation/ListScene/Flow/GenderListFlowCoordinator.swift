//
//  GenderListFlowCoordinator.swift
//  GenderList
//
//  Created by RONICK on 2023/07/11.
//

import UIKit

protocol GenderListFlowCoodinatorDependencies {
    func makeGenderListViewController() -> GenderListViewController
    func makeGenderDetailsViewController(genderProfileItem: GenderProfileItemViewModel) -> DetailViewController
}

final class GenderListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    
    private let dependencies: GenderListFlowCoodinatorDependencies
    
    private weak var GenderListVC: GenderListViewController?
    
    init(navigationController: UINavigationController, dependencies: GenderListFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeGenderListViewController()
        navigationController?.pushViewController(vc, animated: true)
        GenderListVC = vc
    }
    
    private func showDetailList(genderProfileItem: GenderProfileItemViewModel) {
        let vc = dependencies.makeGenderDetailsViewController(genderProfileItem: genderProfileItem)
        navigationController?.pushViewController(vc, animated: true)
    }
}
