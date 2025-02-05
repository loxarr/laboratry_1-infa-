//
//  CoinsListAssembly.swift
//  CryptoStatistics
//
// 
//

import Foundation

final class CoinsListAssembly: Assembly {

    private var coinsListCoordinator: ICoinsListCoordinator?
    private let container = DIContainer.shared

    func view(with name: String? = nil) throws -> CoinsListViewController {
        guard let coinsListCoordinator = coinsListCoordinator else {
            throw AssemblyError.coordinatorNotSet("Coordinator Error")
        }
        do {
            let coinsListViewModel = CoinsListViewModel(
                coinsListCoordinator: coinsListCoordinator,
                modelConversationService: try container.resolve(IModelConversionService.self),
                networkService: try container.resolve(INetworkService.self),
                delayManager: try container.resolve(IDelayManager.self),
                storageService: try container.resolve(IStorageService.self),
                coreDataService: try DIContainer.shared.resolve(ICoreDataService.self)
            )
            let coinsListViewController = CoinsListViewController(coinsListViewModel: coinsListViewModel)
            return coinsListViewController
        } catch let error {
            throw error
        }
    }

    func setCoordinator(_ coordinator: CoinsListCoordinator?) {
        self.coinsListCoordinator = coordinator
    }
}
