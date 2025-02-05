//
//  Assembly.swift
//  CryptoStatistics
//
// 
//

import UIKit

protocol Assembly {
    associatedtype Controller: UIViewController
    associatedtype CoordinatorType: Coordinator
    func view(with name: String?) throws -> Controller
    func setCoordinator(_ coordinator: CoordinatorType?)
}
