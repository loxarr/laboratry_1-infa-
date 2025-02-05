//
//  AuthCoordinator.swift
//  CryptoStatistics
//
//  
//

import UIKit

protocol IAuthCoordinator: Coordinator {
    func goToListViewController() throws
    func goToListViewController(in window: UIWindow) throws
}

// MARK: - AuthCoordinator
final class AuthCoordinator: IAuthCoordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    private weak var authAssembly: AuthAssembly?

    init(      
        authAssembly: AuthAssembly,
        navigationController: UINavigationController
    ) {
        self.authAssembly = authAssembly
        self.navigationController = navigationController
    }
}

//MARK: - Internal methods
extension AuthCoordinator {
    
    func start(in window: UIWindow) throws {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        do {
            let authViewController = try authAssembly?.view()
            if let authViewController {
                navigationController.pushViewController(authViewController, animated: true)
            }
        } catch let error {
            throw error
        }
    }

    func start() throws {
        do {
            let authViewController = try authAssembly?.view()
            if let authViewController {
                navigationController.switchRootController(
                    to: [authViewController],
                    animated: true,
                    options: .transitionFlipFromLeft
                )
            }
        } catch let error {
            throw error
        }
    }

    func goToListViewController() throws {
        let coinsListAssembly = CoinsListAssembly()
        let coinsListCoordinator = CoinsListCoordinator(
            navigationController: navigationController,
            coinsListAssembly: coinsListAssembly
        )
        coinsListAssembly.setCoordinator(coinsListCoordinator)
        childCoordinators.append(coinsListCoordinator)
        do {
            try coinsListCoordinator.start()
        } catch let error {
            throw error
        }
    }

    /// вызывает метод start(in: window) если пользователь авторизован
    func goToListViewController(in window: UIWindow) throws {
        let coinsListAssembly = CoinsListAssembly()
        let coinsListCoordinator = CoinsListCoordinator(
            navigationController: navigationController,
            coinsListAssembly: coinsListAssembly
        )
        coinsListAssembly.setCoordinator(coinsListCoordinator)
        childCoordinators.append(coinsListCoordinator)
        do {
            try coinsListCoordinator.start(in: window)
        } catch let error {
            throw error
        }
    }
}
