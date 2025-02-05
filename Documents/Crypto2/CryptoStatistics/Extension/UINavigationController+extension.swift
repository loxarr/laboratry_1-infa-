//
//  UIWindow+extension.swift
//  CryptoStatistics
//
//  
//

import UIKit

extension UINavigationController {

    func switchRootController(
        to newViewControllers: [UIViewController],
        animated: Bool,
        options: UIView.AnimationOptions,
        duration: TimeInterval = 0.5,
        completion: (() -> Void)? = nil
    ) {
        viewControllers.forEach { $0.removeFromParent() }
        guard animated else {
            viewControllers = newViewControllers
            return
        }

        UIView.transition(
            with: self.view,
            duration: duration,
            options: options,
            animations: { [self] in
                let oldState = UIView.areAnimationsEnabled
                viewControllers = newViewControllers
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                completion?()
            })
        self.navigationItem.backBarButtonItem = .none
    }
}
