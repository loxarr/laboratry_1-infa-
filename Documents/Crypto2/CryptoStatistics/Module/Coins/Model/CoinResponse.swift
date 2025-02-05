//
//  CoinsListResponse.swift
//  CryptoStatistics
//
//
//

import Foundation

struct CoinResponse: Codable {
    let data: Data

    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Data: Codable {
    let name: String
    let currentPrice: Price

    enum CodingKeys: String, CodingKey {
        case name
        case currentPrice = "market_data"
    }
}

struct Price: Codable {
    let USDValue: Double
    let dayValue: DayValue

    enum CodingKeys: String, CodingKey {
        case USDValue = "price_usd"
        case dayValue = "ohlcv_last_24_hour"
    }
}

struct DayValue: Codable {
    let openPrice: Double
    let closePrice: Double

    enum CodingKeys: String, CodingKey {
        case openPrice = "open"
        case closePrice = "close"
    }
}
