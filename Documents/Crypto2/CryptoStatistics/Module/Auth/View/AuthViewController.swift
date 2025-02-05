//
//  AuthViewController.swift
//  CryptoStatistics
//
//  
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {

    enum UserInfo {
        static let email = "1234"
        static let password = "1234"
    }

    // MARK: Constants

    private enum Constants {
        static let loginTextFieldText = "Login"
        static let passwordTextFieldText = "Password"
        static let buttonText = "Go"
    }

    // MARK: private properties

    private var authViewModel: IAuthViewModel

    private lazy var textFieldsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppConstants.normalSpacing
        return stack
    }()

    private lazy var loginTextFieldView: TextFieldView = {
        let textFieldView = TextFieldView(key: .login)
        textFieldView.placeholderText = Constants.loginTextFieldText
        textFieldView.delegate = self
        return textFieldView
    }()

    private lazy var passwordTextFieldView: TextFieldView = {
        let textFieldView = TextFieldView(key: .password)
        textFieldView.placeholderText = Constants.passwordTextFieldText
        textFieldView.delegate = self
        return textFieldView
    }()

    private lazy var buttonView: CustomButton = {
        let button = CustomButton()
        button.title = Constants.buttonText
        button.addTarget(
            self,
            action: #selector(didTapButton),
            for: .touchUpInside
        )
        return button
    }()

    // MARK: Initialization

    init(authViewModel: IAuthViewModel) {
        self.authViewModel = authViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
}

//MARK: - Internal methods
extension AuthViewController: TextFieldViewDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let customTextField = textField as? CustomTextField {
            switch customTextField.key {
            case .login:
                authViewModel.userLogin = customTextField.text
            case .password:
                authViewModel.userPassword = customTextField.text
            default:
                break
            }
        }
    }

    /// Для клавиатуры мака
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inputText = (textField.text as? NSString)?.replacingCharacters(in: range, with: string)

        if let customTextField = textField as? CustomTextField {
            switch customTextField.key {
            case .login:
                authViewModel.userLogin = inputText
            case .password:
                authViewModel.userPassword = inputText
            default:
                return false
            }
        }
        return true
    }

}

//MARK: - AuthViewModelDelegate
extension AuthViewController: AuthViewModelDelegate {

    func showError(with message: String?, _ key: TextFieldType) {
        switch key {
        case .login:
            loginTextFieldView.showError(with: message)
        case .password:
            passwordTextFieldView.showError(with: message)
        }
    }
}

//MARK: - @objc methods
@objc
extension AuthViewController {

    func didTapButton() {
        do {
            try authViewModel.didTapButton()
        } catch {
            print(error)
        }
    }

    func dismissKeyboard() {
        // Закрыть клавиатуру
        view.endEditing(true)
    }
}

//MARK: - private methods
private extension AuthViewController {

    func setupUI() {
        view.backgroundColor = Assets.Colors.dark
        configureLayout()
    }

    func configureLayout() {
        textFieldsStackView.addArrangesSubviews([passwordTextFieldView, loginTextFieldView])
        view.addSubviews([textFieldsStackView, buttonView])

        textFieldsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
        }

        buttonView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(AppConstants.normalSpacing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(AppConstants.normalSpacing)
        }
    }
}
