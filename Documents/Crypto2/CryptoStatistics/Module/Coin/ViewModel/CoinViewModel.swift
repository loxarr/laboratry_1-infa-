//
//  CoinViewModel.swift
//  CryptoStatistics
//
//
//

import Foundation
import Combine

//MARK: - ICoinViewModel

protocol ICoinViewModel {
    var coin: CoinConvertedModel? { get }
    var didUpdateCoin: ((CoinConvertedModel?) -> Void)? { get set }
    var switchViewState: ((_ state: CurrentState) -> Void)? { get set }
    func fetchCoin()
}

//MARK: - CoinViewModel

final class CoinViewModel: ICoinViewModel {

    // MARK: Constants

    private enum Constants {
        static let outputDateFormat = "dd.MM.yyyy hh:mm a"
    }

    // MARK: Internal properties

    var coin: CoinConvertedModel?
    var didUpdateCoin: ((CoinConvertedModel?) -> Void)?
    var switchViewState: ((_ state: CurrentState) -> Void)?

    // MARK: Private properties

    private let coinCoordinator: Coordinator
    private let networkService: INetworkService
    private let modelConversationService: IModelConversionService

    private var coinName: String

    // MARK: Initialization

    init(
        coinCoordinator: Coordinator,
        networkService: INetworkService,
        modelConversationService: IModelConversionService,
        coinName: String
    ) {
        self.coinCoordinator = coinCoordinator
        self.networkService = networkService
        self.modelConversationService = modelConversationService
        self.coinName = coinName
    }
}

//MARK: - Internal methods
extension CoinViewModel {

    func fetchCoin() {
        switchViewState?(.loading)
        networkService.getData(with: Endpoint.coin(coinName).url) { [weak self] (result: Result<CoinResponse, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                let convertedModel = convertToLocaleModel(result)
                if let convertedModel = convertedModel {
                    self.coin = convertedModel
                    self.didUpdateCoin?(self.coin)
                }
            case .failure(let error):
                switch error {
                case .clientError(let value):
                    guard value != 404, value != 429 else { break } // появля.тся из за бека
                    switchViewState?(.failed(errorMessage: "Проверьте подключение"))
                case .decodingError, .noData, .responseError, .urlError, .requestError:
                    switchViewState?(.failed(errorMessage: "Проблема. Уже исправляем"))
                case .serverError(_):
                    switchViewState?(.failed(errorMessage: "Ошибка на сервере"))
                case .invalidResponseCode(_):
                    switchViewState?(.failed(errorMessage: "Ошибка на сервере"))
                }
            }
            switchViewState?(.loaded)
        }
    }
}

//MARK: - Private methods
private extension CoinViewModel {

    func convertToLocaleModel(_ coinResponse: CoinResponse) -> CoinConvertedModel? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.outputDateFormat
        let dateString = dateFormatter.string(from: date)
        let localModel = modelConversationService.convertServerCoinModelToApp(coinResponse, date: dateString)
        return localModel
    }
}
