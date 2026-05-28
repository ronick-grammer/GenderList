//
//  SceneDelegate.swift
//  GenderList
//
//  Created by Ronick on 6/20/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let appDIContainer = AppDIContainer()
    
    private var appFlowCoordinator: AppFlowCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        navigationController.navigationBar.backgroundColor = .clear
        navigationController.navigationBar.isTranslucent = false
        
        window?.rootViewController = navigationController
        let coordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        
        appFlowCoordinator = coordinator
        
        coordinator.start()
        window?.backgroundColor = .systemBackground
        window?.makeKeyAndVisible()
    }

}

