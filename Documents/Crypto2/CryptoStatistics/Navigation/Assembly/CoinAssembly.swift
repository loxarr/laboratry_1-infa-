//
//  CoinAssembly.swift
//  CryptoStatistics
//
// 
//

import Foundation

final class CoinAssembly: Assembly {
    
    private var coinCoordinator: Coordinator?
    private let container = DIContainer.shared

    func view(with name: String?) throws -> CoinViewController {
        guard let coinCoordinator = coinCoordinator else {
            throw AssemblyError.coordinatorNotSet("Coordinator Error")
        }
        do {
            let coinViewModel = CoinViewModel(
                coinCoordinator: coinCoordinator,
                networkService: try container.resolve(INetworkService.self),
                modelConversationService: try container.resolve(IModelConversionService.self),
                coinName: name ?? ""
            )
            let coinViewController = CoinViewController(coinViewModel: coinViewModel)
            return coinViewController
        } catch let error {
            throw error
        }
    }

    func setCoordinator(_ coordinator: CoinCoordinator?) {
        self.coinCoordinator = coordinator
    }
}
