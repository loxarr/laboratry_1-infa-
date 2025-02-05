//
//  AuthAssembly.swift
//  CryptoStatistics
//
// 
//

import UIKit

final class AuthAssembly: Assembly {

    private var authCoordinator: IAuthCoordinator?
    private let container = DIContainer.shared

    func view(with name: String? = nil) throws -> AuthViewController {
        guard let authCoordinator else {
            throw AssemblyError.coordinatorNotSet("Coordinator Error")
        }
        let authViewModel = AuthViewModel(
            storageService: try DIContainer.shared.resolve(IStorageService.self),
            authCoordinator: authCoordinator
        )
        let authViewController = AuthViewController(authViewModel: authViewModel)
        authViewModel.delegate = authViewController
        return authViewController

    }

    func setCoordinator(_ coordinator: AuthCoordinator?) {
        self.authCoordinator = coordinator
    }
}
