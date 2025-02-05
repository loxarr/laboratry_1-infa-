//
//  TextFieldView.swift
//  CryptoStatistics
//
//  
//

import Foundation
import UIKit

//MARK: TextFieldViewDelegate
protocol TextFieldViewDelegate: AnyObject {
    func textFieldDidEndEditing(_ textField: UITextField)
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool
}

final class TextFieldView: UIView {

    // MARK: Constants

    private enum Constants {
        static let spacing: CGFloat = 2
    }

    //MARK: Internal properties

    weak var delegate: TextFieldViewDelegate?

    var placeholderText: String? {
        didSet {
            customTextField.placeholderText = placeholderText
        }
    }

    //MARK: Private properties

    private let key: TextFieldType?

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = Constants.spacing
        stack.axis = .vertical
        return stack
    }()

    private lazy var customTextField: CustomTextField = {
        let textField = CustomTextField(key: key)
        textField.customDelegate = self
        return textField
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = RegularFont.p3
        label.textColor = Assets.Colors.red
        return label
    }()

    //MARK: Initialization

    init(key: TextFieldType?) {
        self.key = key
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - Internal methods
extension TextFieldView {

    func showError(with errorMessage: String?) {
        errorLabel.text = errorMessage
        customTextField.isError = errorMessage.isNotEmpty
        errorLabel.isHidden = !errorMessage.isNotEmpty
    }
}

//MARK: - CustomTextFieldDelegate
extension TextFieldView: CustomTextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideError()
        return delegate?.textField(
            textField,
            shouldChangeCharactersIn: range,
            replacementString: string
        ) ?? true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField)
    }
}

//MARK: - Private methods
private extension TextFieldView {

    func setupUI() {
        configureLayout()
    }

    func configureLayout() {
        addSubview(stackView)
        stackView.addArrangedSubview(customTextField)
        stackView.addArrangedSubview(errorLabel)
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func hideError() {
        customTextField.isError = false
        errorLabel.isHidden = true
    }

}
