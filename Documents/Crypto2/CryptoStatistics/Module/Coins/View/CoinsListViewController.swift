//
//  CoinsListViewController.swift
//  CryptoStatistics
//
//
//

import UIKit
import Combine

// MARK: - Request Reasons
enum RequestReason {
    case firstLoad
    case update
}

// MARK: - CoinsListViewController
final class CoinsListViewController: UIViewController {

    // MARK: Constants

    private enum Constants {
        static let rightBarButtonText = "Logout"
        static let leftBarButtonText = "Sort"
        static let alertControllerTitle = "Sort by"
        static let sortByReducingTitle = "Reducing price changes"
        static let sortByIncreasingTitle = "Increasing price changes"
        static let cancelAction = "Отмена"
        static let okAction = "Ok"
    }

    // MARK: Internal properties

    var currentState: CurrentState?

    // MARK: Private properties

    private var coinsListViewModel: ICoinsListViewModel
    private let refreshControl = UIRefreshControl()
    private var cancellable = Set<AnyCancellable>()

    private let sortAlertController = UIAlertController(
        title: Constants.alertControllerTitle,
        message: nil,
        preferredStyle: .actionSheet
    )

    private let errorAlertController = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .alert
    )

    //MARK: UI Elements

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = Assets.Colors.grayLight
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = Assets.Colors.dark
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            CoinTableViewCell.self,
            forCellReuseIdentifier: CoinTableViewCell.identifier
        )
        return tableView
    }()

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        coinsListViewModel.fetchCoins(.firstLoad)
    }

    // MARK: Initialization

    init(coinsListViewModel: ICoinsListViewModel) {
        self.coinsListViewModel = coinsListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - TableViewDelegate
extension CoinsListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinsListViewModel.convertedCoinsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinTableViewCell.identifier, for: indexPath) as? CoinTableViewCell else {
            return UITableViewCell()
        }
        let coin = coinsListViewModel.convertedCoinsArray[indexPath.row]
        cell.configure(with: coin)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coinName = coinsListViewModel.convertedCoinsArray[indexPath.row].coinName
        coinsListViewModel.goToCoinViewController(with: coinName)

    }
}

// MARK: - @objc methods
@objc
private extension CoinsListViewController {

    func logoutButtonTapped() {
        coinsListViewModel.goToAuth()
    }

    func sortButtonTapped() {
        self.present(sortAlertController, animated: true)
    }

    func refreshControlPulled() {
        coinsListViewModel.fetchCoins(.update)
    }
}

// MARK: - Private methods
private extension CoinsListViewController {

    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = false
        configureLayout()
        addRightBarButtonItem()
        addLeftBarButtonItem()
        setupAlertController()
        setupErrorAlertController()
    }

    func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func setupViewModel() {
        coinsListViewModel.didUpdateCoinsList = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        coinsListViewModel.switchViewState = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.currentState = state
                switch self.currentState {
                case .loading:
                    self.activityIndicator.startAnimating()
                case .loaded:
                    self.activityIndicator.stopAnimating()
                    self.setupRefreshControl()
                case .updated:
                    self.refreshControl.endRefreshing()
                case .failed(let errorMessage):
                    self.showErrorAlert(with: errorMessage)
                case .none:
                    break
                }
            }
        }
    }

    func addRightBarButtonItem() {
        let logoutButton = UIBarButtonItem(
            title: Constants.rightBarButtonText,
            style: .done,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }

    func addLeftBarButtonItem() {
        let sortButton = UIBarButtonItem(
            title: Constants.leftBarButtonText,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        navigationItem.leftBarButtonItem = sortButton
    }

    func setupAlertController() {
        ///убывание
        let sortByReducingAction = UIAlertAction(
            title: Constants.sortByReducingTitle,
            style: .default
        ) { _ in
            self.coinsListViewModel.sortCoins(by: .reduce)
        }
        ///возрастание
        let sortByIncreasingAction = UIAlertAction(
            title: Constants.sortByIncreasingTitle,
            style: .default
        ) { _ in
            self.coinsListViewModel.sortCoins(by: .increasing)
        }
        let cancelAction = UIAlertAction(
            title: Constants.cancelAction,
            style: .cancel
        )
        cancelAction.setValue(Assets.Colors.red, forKey: "titleTextColor")
        sortAlertController.addAction(sortByReducingAction)
        sortAlertController.addAction(sortByIncreasingAction)
        sortAlertController.addAction(cancelAction)
    }

    func setupRefreshControl() {
        refreshControl.tintColor = Assets.Colors.grayLight
        refreshControl.addTarget(
            self,
            action: #selector(refreshControlPulled),
            for: .valueChanged
        )
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }

    func showErrorAlert(with title: String) {
        DispatchQueue.main.async {
            self.errorAlertController.title = title
            self.present(self.errorAlertController, animated: true)
        }
    }

    func setupErrorAlertController() {
        let okAction = UIAlertAction(
            title: Constants.okAction,
            style: .default
        )
        okAction.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        errorAlertController.addAction(okAction)
    }
}
