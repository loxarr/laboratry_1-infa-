//
//  Endpoint.swift
//  CryptoStatistics
//
//  
//

import Foundation

private struct API {
    static let scheme = "https"
    static let host = "data.messari.io"
    static let path = "/api/v1/assets/"
}

enum Endpoint {
    case coin(_ name: String)
}

extension Endpoint {
    var url: String {
        switch self {
        case .coin(let name):
            .makeURLForEndpoint("\(name)/metrics")
        }
    }
}

private extension String {
    static func makeURLForEndpoint(_ endpoint: String) -> String {
        var url: String {
            var components = URLComponents()
            components.scheme = API.scheme
            components.host = API.host
            components.path = API.path + endpoint
            return components.string ?? ""
        }
        return url
    }
}
