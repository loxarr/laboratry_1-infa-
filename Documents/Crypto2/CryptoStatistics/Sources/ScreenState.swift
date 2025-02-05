//
//  ScreenState.swift
//  CryptoStatistics
//
//  
//

import Foundation

// MARK: - Screen States
enum CurrentState {
    case loading
    case loaded
    case updated
    case failed(errorMessage: String)
}
