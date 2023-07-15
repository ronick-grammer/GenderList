//
//  GenderListDetailFlowCoordinator.swift
//  GenderList
//
//  Created by RONICK on 2023/07/13.
//

import Foundation

import UIKit

protocol GenderListDetailFlowCoodinatorDependencies {
    func makeGenderListDetailViewController() -> DetailViewController
}

final class GenderListDetailFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var parentCoordinator: AppFlowCoordinator?
    
    private let dependencies: GenderListDetailFlowCoodinatorDependencies
    
    init(navigationController: UINavigationController, parentCoordinator: AppFlowCoordinator, dependencies: GenderListDetailFlowCoodinatorDependencies) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
        self.dependencies = dependencies
    }
    
    func start() {
        let vc = dependencies.makeGenderListDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
