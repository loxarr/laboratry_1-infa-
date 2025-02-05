//
//  CustomTextField.swift
//  CryptoStatistics
//
//  
//

import UIKit
import SnapKit

// MARK: - CustomTextFieldDelegate
protocol CustomTextFieldDelegate: AnyObject {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool
    func textFieldDidEndEditing(_ textField: UITextField)
}

enum TextFieldType {
    case password
    case login
}

// MARK: - CustomTextField
final class CustomTextField: UITextField {

    // MARK: TextFieldSize

    enum TextFieldSize {
        case primary

        var height: Int {
            switch self {
            case .primary:
                48
            }
        }
    }

    // MARK: Constants

    private enum Constants {
        static let paddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        static let boarderRadius: CGFloat = 23
        static let borderWidth: CGFloat = 1

        static let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .font: SemiboldFont.h3,
            .foregroundColor: Assets.Colors.white
        ]
    }

    // MARK: Internal properties

    weak var customDelegate: CustomTextFieldDelegate?
    let key: TextFieldType?

    var placeholderText: String? {
        didSet {
            guard let placeholderText else { return }
            attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: Constants.placeholderAttributes
            )
        }
    }

    var isError = false {
        didSet {
            layer.borderColor = isError 
            ? Assets.Colors.red.cgColor
            : Assets.Colors.white.cgColor
        }
    }

    // MARK: Private properties

    private let size: TextFieldSize

    // MARK: Initialization

    init(
        size: TextFieldSize = .primary,
        key: TextFieldType?
    ) {
        self.size = size
        self.key = key
        super.init(frame: .zero)
        delegate = self
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal methods
extension CustomTextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.paddings)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.paddings)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: Constants.paddings)
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        return customDelegate?.textField(
            textField,
            shouldChangeCharactersIn: range,
            replacementString: string
        ) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        customDelegate?.textFieldDidEndEditing(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private methods
private extension CustomTextField {

    func setupUI() {
        layer.cornerRadius = Constants.boarderRadius
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = Assets.Colors.white.cgColor
        font = SemiboldFont.h3
        textColor = Assets.Colors.white
        configureLayout()
    }

    func configureLayout() {
        snp.makeConstraints {
            $0.height.equalTo(size.height)
        }
    }
}
