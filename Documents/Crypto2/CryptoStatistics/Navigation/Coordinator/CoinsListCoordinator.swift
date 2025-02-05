//
//  CoinsListCoordinator.swift
//  CryptoStatistics
//
// 
//

import UIKit

protocol ICoinsListCoordinator: Coordinator {
    func goToAuthViewController() throws
    func goToCoinViewController(with name: String) throws
}

// MARK: - CoinsListCoordinator
final class CoinsListCoordinator: ICoinsListCoordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    private weak var coinsListAssembly: CoinsListAssembly?

    init(
        navigationController: UINavigationController,
        coinsListAssembly: CoinsListAssembly
    ) {
        self.navigationController = navigationController
        self.coinsListAssembly = coinsListAssembly
    }
}

//MARK: - Internal methods
extension CoinsListCoordinator {

    func start() throws {
        do {
            let coinsListViewController = try coinsListAssembly?.view()
            if let coinsListViewController {
                navigationController.switchRootController(
                    to: [coinsListViewController],
                    animated: true,
                    options: .transitionFlipFromRight
                )
            }
        } catch let error {
            throw error
        }
    }

    /// метод если пользователь авторизован
    func start(in window: UIWindow) throws {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        do {
            let coinsListViewController = try coinsListAssembly?.view()
            if let coinsListViewController {
                navigationController.pushViewController(coinsListViewController, animated: true)
            }
        } catch let error {
            throw error
        }
    }

    /// возвращает на экран авторизации
    func goToAuthViewController() throws {
        let authAssembly = AuthAssembly()
        let authCoordinator = AuthCoordinator(
            authAssembly: authAssembly,
            navigationController: navigationController
        )
        authAssembly.setCoordinator(authCoordinator)
        do {
            try authCoordinator.start()
        } catch let error {
            throw error
        }
    }

    func goToCoinViewController(with name: String) throws {
        let coinAssembly = CoinAssembly()
        let coinCoordinator = CoinCoordinator(
            navigationController: navigationController,
            coinAssembly: coinAssembly
        )
        coinAssembly.setCoordinator(coinCoordinator)
        childCoordinators.append(coinCoordinator)
        do {
            try coinCoordinator.start(with: name)
        } catch let error {
            throw error
        }
    }
}
