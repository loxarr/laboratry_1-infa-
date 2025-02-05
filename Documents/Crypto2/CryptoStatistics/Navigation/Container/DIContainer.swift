//
//  DIContainer.swift
//  CryptoStatistics
//
//
//

import Foundation

//MARK: - IDIContainer
protocol IDIContainer {
    func register<T>(_ type: T.Type, _ factory: @escaping () throws -> AnyObject)
    func resolve<T>(_ type: T.Type) throws -> T
}

//MARK: - DIContainer
final class DIContainer: IDIContainer {

    static let shared = DIContainer()
    private init() {}

    private let concurrentQueue = DispatchQueue(label: "queue", attributes: .concurrent)

    var dependencies = [String: () throws -> AnyObject]()

    func register<T>(_ type: T.Type, _ factory: @escaping () throws -> AnyObject) {
        concurrentQueue.async(flags: .barrier) {
            self.dependencies["\(type)"] = factory
        }
    }

    func resolve<T>(_ type: T.Type) throws -> T {
        try concurrentQueue.sync {
            guard let factory = dependencies["\(type)"], let dependency = try factory() as? T else {
                throw DIContainerError.dependencyNotFound("\(type)")
            }
            return dependency
        }
    }
}

