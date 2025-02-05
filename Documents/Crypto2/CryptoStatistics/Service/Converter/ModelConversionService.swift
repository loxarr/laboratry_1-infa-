//
//  ModelConversionService.swift
//  CryptoStatistics
//
// 
//

import Foundation

protocol IModelConversionService {
    func convertServerCoinsModelToApp(_ coinsListResponse: CoinResponse, date: String) -> CoinsListTableViewCellModel
    func convertServerCoinModelToApp(_ coinResponse: CoinResponse, date: String) -> CoinConvertedModel
}

//MARK: - ModelConversionService
final class ModelConversionService: IModelConversionService {

    /// Список монет
    func convertServerCoinsModelToApp(_ coinsListResponse: CoinResponse, date: String) -> CoinsListTableViewCellModel {

        let localModel = CoinsListTableViewCellModel(
            coinName: coinsListResponse.data.name,
            currentPrice: getConvertedPrice(coinsListResponse.data.currentPrice.USDValue),
            dayDynamicPercents: getConvertedPercents(coinsListResponse.data.currentPrice.dayValue.closePrice, coinsListResponse.data.currentPrice.dayValue.openPrice),
            date: date
        )
        return localModel
    }

    ///  Подробная информация о монете
    func convertServerCoinModelToApp(_ coinResponse: CoinResponse, date: String) -> CoinConvertedModel {
        let localeModel = CoinConvertedModel(
            coinName: coinResponse.data.name,
            currentPrice: getConvertedPrice(coinResponse.data.currentPrice.USDValue),
            openDayPrice: getConvertedOpenPrice(coinResponse.data.currentPrice.dayValue.openPrice),
            closeDayPrice: getConvertedOpenPrice(coinResponse.data.currentPrice.dayValue.closePrice),
            dayDynamicPercents: getConvertedPercents(coinResponse.data.currentPrice.dayValue.closePrice, coinResponse.data.currentPrice.dayValue.openPrice),
            date: date
        )
        return localeModel
    }
}

//MARK: - CoinsListTableViewCellModel methods
private extension ModelConversionService {

    func getConvertedPercents(_ value1: Double, _ value2: Double) -> Double {
        let temp = (value1 - value2) / value1
        return (temp * 1000).rounded() / 1000
    }

    func getConvertedOpenPrice(_ value: Double) -> Double {
        return (value * 1000).rounded() / 1000
    }

    func getConvertedClosePrice(_ value: Double) -> Double {
        return (value * 1000).rounded() / 1000
    }

    func getConvertedPrice(_ price: Double) -> Double {
        return (price * 1000).rounded() / 1000

    }
}
