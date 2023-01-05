//
//  UIAlertController+Extensions.swift
//  GitCoMing
//
//  Created by Kim dohyun on 2023/01/05.
//

import UIKit


public enum GitComingButtonType {
    case cancel, confirm
}


public final class GitComingAlert: UIAlertController {
    
    //MARK: Property
    public static let shared: GitComingAlert = GitComingAlert(extra: "")
    
    public var confirmHandler: () -> Void = {}
    public var cancelHandler: () -> Void = {}
    
    
    private convenience init(
        title: String = "",
        message: String = "",
        preferredStyle: UIAlertController.Style = .alert,
        extra: String
    ) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
    }
    
    
    /// 타이틀 설정
    @discardableResult
    public func setTitle(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    /// 메세지 설정
    @discardableResult
    public func setMessage(_ message: String) -> Self {
        self.message = message
        return self
    }
    
    /// 버튼 설정
    @discardableResult
    public func setButtons(_ type: GitComingButtonType, title: String) -> Self {
        var action: UIAlertAction!

        switch type {
        case .confirm:
            action = .init(
                title: title,
                style: .default,
                handler: { [weak self] _ in
                    self?.confirmHandler()
                }
            )
        case .cancel:
            action = .init(
                title: title,
                style: .cancel,
                handler: { [weak self] _ in
                    self?.cancelHandler()
                }
            )
        }
        
        addAction(action)
        return self
    }
    
    
    @discardableResult
    public func show(viewController: UIViewController? = nil) -> Self {
        if actions.isEmpty {
            let action: UIAlertAction = .init(
              title: "확인",
              style: .default,
              handler: { [weak self] _ in
                self?.confirmHandler()
              })
            addAction(action)
        }
        
        DispatchQueue.main.async {
            guard let viewController = viewController else { return }
            viewController.present(self, animated: true)
        }
        return self
    }
    
    
    
    
    
}



