//
//  CoinViewController.swift
//  CryptoStatistics
//
//
//

import UIKit
import Combine

//MARK: - CoinViewController
final class CoinViewController: UIViewController {

    // MARK: Constants

    private enum Constants {
        static let openPriceLabelText = "Start price today: "
        static let сlosePriceLabelText = "Final price today: "
        static let percentsLabelText = "Price changed: "
        static let currentPriceLabelText = "Price: "
        static let okAction = "Ok"
    }

    //MARK: Internal properties

    var currentState: CurrentState?

    //MARK: Private properties

    private var coinViewModel: ICoinViewModel

    private var cancellable = Set<AnyCancellable>()

    private var percentsLabelColor: UIColor? {
        didSet {
            self.percentsLabel.textColor = percentsLabelColor
        }
    }

    private let alertController = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .alert
    )

    //MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        coinViewModel.fetchCoin()
    }

    //MARK: UI Elements

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Assets.Colors.grayLight
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = AppConstants.normalSpacing
        return stack
    }()

    private lazy var openPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.white
        label.font = SemiboldFont.h2
        return label
    }()

    private lazy var closePriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Assets.Colors.white
        label.font = SemiboldFont.h2
        return label
    }()

    private lazy var percentsLabel: UILabel = {
        let label = UILabel()
        label.font = SemiboldFont.h2
        return label
    }()

    private lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = SemiboldFont.h2
        label.textColor = Assets.Colors.white
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p3
        label.textColor = Assets.Colors.grayLight
        return label
    }()

    //MARK: Initialization

    init(coinViewModel: ICoinViewModel) {
        self.coinViewModel = coinViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Private methods
private extension CoinViewController {

    func setupUI() {
        view.backgroundColor = Assets.Colors.dark
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: Assets.Colors.white]
        configureLayout()
        setupAlertController()
    }

    func configureLayout() {
        view.addSubview(stackView)
        stackView.addArrangesSubviews([percentsLabel, openPriceLabel, closePriceLabel, currentPriceLabel, dateLabel])
        view.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
        }
    }

    func setupViewModel() {
//        coinViewModel.didUpdateCoin
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] coin in
//                guard let coin = coin, let self = self else { return }
//                self.navigationItem.title = coin.coinName
//                self.openPriceLabel.text = Constants.openPriceLabelText + "\(coin.openDayPrice)$"
//                self.closePriceLabel.text = Constants.сlosePriceLabelText + "\(coin.closeDayPrice)$"
//                self.percentsLabel.text = Constants.percentsLabelText + "\(coin.dayDynamicPercents)%"
//                self.currentPriceLabel.text = Constants.currentPriceLabelText + "\(coin.currentPrice)$"
//                self.dateLabel.text = "\(coin.date)"
//                self.percentsLabelColor = (coin.dayDynamicPercents > 0) ? Assets.Colors.lime : Assets.Colors.red
//            }.store(in: &cancellable)

        coinViewModel.didUpdateCoin = { [weak self] coin in
            DispatchQueue.main.async {
                guard let coin = coin, let self = self else { return }
                self.navigationItem.title = coin.coinName
                self.openPriceLabel.text = Constants.openPriceLabelText + "\(coin.openDayPrice)$"
                self.closePriceLabel.text = Constants.сlosePriceLabelText + "\(coin.closeDayPrice)$"
                self.percentsLabel.text = Constants.percentsLabelText + "\(coin.dayDynamicPercents)%"
                self.currentPriceLabel.text = Constants.currentPriceLabelText + "\(coin.currentPrice)$"
                self.dateLabel.text = "\(coin.date)"
                self.percentsLabelColor = (coin.dayDynamicPercents > 0)
                ? Assets.Colors.lime
                : Assets.Colors.red
            }
        }

        coinViewModel.switchViewState = { [weak self] state in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.currentState = state
                switch self.currentState {
                case .loading:
                    self.activityIndicator.startAnimating()
                case .loaded:
                    self.activityIndicator.stopAnimating()
                case .updated:
                    break
                case .failed(let errorMessage):
                    self.showAlert(with: errorMessage)
                case .none:
                    break
                }
            }
        }
    }

    func showAlert(with title: String) {
        DispatchQueue.main.async {
            self.alertController.title = title
            self.present(self.alertController, animated: true)
        }
    }

    func setupAlertController() {
        let okAction = UIAlertAction(
            title: Constants.okAction,
            style: .default
        )
        okAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        alertController.addAction(okAction)
    }

}
