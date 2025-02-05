//
//  StorageService.swift
//  CryptoStatistics
//
//
//

import Foundation

//MARK: - String extension
extension String {
    static let key = "isAuth"
}

//MARK: - IStorageService
protocol IStorageService {
    func save(isAuth: Bool)
    func load() -> Bool
}

//MARK: - StorageService
final class StorageService: IStorageService {

    //MARK: Private properties

    private let queue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)

    //MARK: Initialization

//    static let shared = StorageService()
//    private init() {}
}

//MARK: - Internal methods
extension StorageService {

    func save(isAuth: Bool) {
        queue.async(flags: .barrier) {
            UserDefaults.standard.setValue(isAuth, forKey: .key)
        }
    }

    /// проверяем авториз или нет
    func load() -> Bool {
        queue.sync {
            guard let isAuth = UserDefaults.standard.object(forKey: .key) as? Bool else { return false }
            return isAuth
        }
    }
}
