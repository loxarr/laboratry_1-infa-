//
//  CoinCoordinator.swift
//  CryptoStatistics
//
//  
//

import UIKit

final class CoinCoordinator: Coordinator {

    var childCoordinators: [any Coordinator] = []
    var navigationController: UINavigationController
    private weak var coinAssembly: CoinAssembly?

    init(
        navigationController: UINavigationController,
        coinAssembly: CoinAssembly
    ) {
        self.navigationController = navigationController
        self.coinAssembly = coinAssembly
    }

    func start(with name: String) throws {
        do {
            let coinViewController = try coinAssembly?.view(with: name)
            if let coinViewController {
                navigationController.pushViewController(coinViewController, animated: true)
            }
        } catch let error {
            throw error
        }
    }
}
