//
//  Optional+extension.swift
//  CryptoStatistics
//
//  
//

import Foundation

extension Optional where Wrapped == String {

    var isNotEmpty: Bool {
        return self != nil || self != ""
    }
}
