//
//  SceneDelegate.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: scene)
        
        willShowSplashController()
    }

    
    private func willShowSplashController() {
        let splashController = SplashViewController(reactor: SplashViewReactor())
        splashController.delegate = self
        window?.rootViewController = splashController
        window?.makeKeyAndVisible()
    }
}



extension SceneDelegate: CoordinatorDelegate {
    func didShowMainController() {
        let signInController = SignInDIContainer().makeViewController()
        
        window?.rootViewController = signInController
        window?.makeKeyAndVisible()
    }
    
    
    
}
