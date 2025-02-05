//
//  CoinTableViewCell.swift
//  CryptoStatistics
//
// 
//

import UIKit
import SnapKit

class CoinTableViewCell: UITableViewCell {

    // MARK: Constants

    private enum Constants {
        static let price = "Price: "
        static let dayChange = "Day change: "
        static let topBottomPadding: CGFloat = 12
    }

    //MARK: Static properties

    static var identifier: String { "\(Self.self)" }

    //MARK: Private properties

    private var percentsLabelColor: UIColor? {
        didSet {
            self.percentsLabel.textColor = percentsLabelColor
        }
    }

    //MARK: UI Elements

    private lazy var rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppConstants.tinySpacing
        return stack
    }()

    private lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()

    private lazy var bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()

    private lazy var coinNameLabel: UILabel = {
        let label = UILabel()
        label.font = SemiboldFont.h2
        label.textColor = Assets.Colors.white
        return label
    }()

    private lazy var percentsLabel: UILabel = {
        let label = UILabel()
        label.font = SemiboldFont.h2
        return label
    }()

    private lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = Assets.Colors.grayLight
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p2
        label.textColor = Assets.Colors.grayLight
        return label
    }()

        //MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Internal methods
extension CoinTableViewCell {

    func configure(with model: CoinsListTableViewCellModel) {
        self.coinNameLabel.text = model.coinName
        self.currentPriceLabel.text = Constants.price + "\(model.currentPrice)$"
        self.dateLabel.text = model.date
        self.percentsLabel.text = Constants.dayChange + "\(model.dayDynamicPercents)%"
        self.percentsLabelColor = (model.dayDynamicPercents > 0) ? Assets.Colors.lime : Assets.Colors.red
    }
}

//MARK: - Override methods
extension CoinTableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        coinNameLabel.text = nil
        currentPriceLabel.text = nil
        percentsLabel.text = nil
        dateLabel.text = nil
    }
}

//MARK: - Private methods
private extension CoinTableViewCell {

    func setupUI() {
        backgroundColor = Assets.Colors.dark
        configureLayout()
    }

    func configureLayout() {
        addSubview(rootStackView)
        rootStackView.addArrangesSubviews([topStackView, bottomStackView])
        topStackView.addArrangesSubviews([coinNameLabel, UIView(), percentsLabel])
        bottomStackView.addArrangesSubviews([dateLabel, UIView(), currentPriceLabel])

        rootStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.topBottomPadding)
            $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
        }
    }
}
