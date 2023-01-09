//
//  GCMNavigationViewController.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/07.
//

import UIKit


public final class GCMNavigationViewController: UINavigationController {
        
    
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: LifeCycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: Configure
    private func configure() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

}


extension UINavigationController {
    public func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
            CATransaction.setCompletionBlock(completion)
            CATransaction.begin()
            self.pushViewController(viewController, animated: animated)
            CATransaction.commit()
    }
    
    
    public func popViewController(animated: Bool = true, completion: @escaping () -> Void) {
        CATransaction.setCompletionBlock(completion)
        CATransaction.begin()
        self.popViewController(animated: animated)
        CATransaction.commit()
    }
}
