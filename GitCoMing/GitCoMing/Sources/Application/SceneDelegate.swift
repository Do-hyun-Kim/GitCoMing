//
//  SceneDelegate.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/04.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    //MARK: Property
    var window: UIWindow?
    private var gitNavigationController: GCMNavigationViewController!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: scene)
        
        if UserDefaults.standard.string(forKey: .accessToken).isEmpty {
            willShowSplashController()
        } else {
            willShowPostController()
        }
    }
}


extension SceneDelegate {
    
    private func willShowSplashController() {
        let splashController = SplashViewController(reactor: SplashViewReactor())
        splashController.delegate = self
        window?.rootViewController = splashController
        window?.makeKeyAndVisible()
    }
    
    private func willShowPostController() {
        
        let postViewController = PostDIContainer().makeViewController()
        
        gitNavigationController = GCMNavigationViewController(
            rootViewController: postViewController
        )
        
        window?.rootViewController = gitNavigationController
        window?.makeKeyAndVisible()
    }
    
}


/// SplashViewDelegate ➡️ LoginViewController RootViewController 전환
extension SceneDelegate: CoordinatorDelegate {
    func didShowLoginController() {
        let signInController = SignInDIContainer().makeViewController()
        
        window?.rootViewController = signInController
        window?.makeKeyAndVisible()
    }
}
