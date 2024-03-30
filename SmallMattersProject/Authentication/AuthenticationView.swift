//
//  AuthenticationScreen.swift
//  SmallMattersProject
//
//  Created by Dmitry on 17.03.2024.
//

import UIKit
import SnapKit

class AuthenticationView: UIView {

    private var viewModel: AuthViewModel?

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 10)
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        return sv
    }()

    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите email"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        return textField
    }()

    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        return textField
    }()

    lazy var credentialsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()

    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()

    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.setTitle("Войти", for: .normal)
        return button
    }()

    lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setTitle("Регистрация", for: .normal)
        return button
    }()

    lazy var gesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView() {
        addSubview(scrollView)
        addSubviewsToScrollView(subviews: logoImageView, credentialsStackView, loginButton, registrationButton)
        setupConstraints()
        scrollView.addTapGestureToDismissKeyboard()
        setLoginButtonAction()
    }

    func setupViewModel(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.top.equalToSuperview().inset(36)
            make.height.width.equalTo(292)
        }

        credentialsStackView.snp.makeConstraints { make in
            make.width.equalTo(252)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).inset(-32)
        }

        loginButton.snp.makeConstraints { make in
            make.width.equalTo(152)
            make.height.equalTo(40)
            make.top.equalTo(passwordTextField.snp.bottom).inset(-30)
            make.centerX.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        registrationButton.snp.makeConstraints { make in
            make.width.equalTo(152)
            make.height.equalTo(40)
            make.bottom.equalTo(scrollView.snp.bottom).inset(90)
            make.centerX.equalToSuperview()
        }
    }

    private func addSubviewsToScrollView(subviews: UIView...) {
        subviews.forEach { scrollView.addSubview($0) }
    }

    @objc func handleTap() {
        print("end editing")
        scrollView.endEditing(true)
    }

    private func setLoginButtonAction() {
        let action = UIAction { [weak self] _ in
            if let self = self {
                self.viewModel?
                    .login(login: self.loginTextField.text ?? "",
                           password: self.passwordTextField.text ?? "")
            }
        }
        loginButton.addAction(action, for: .touchUpInside)
    }
}

extension AuthenticationView: UITextFieldDelegate {
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case loginTextField: 
            passwordTextField.becomeFirstResponder()
            let passwordFieldOrigin = passwordTextField.bounds.origin
            scrollView.setContentOffset(passwordFieldOrigin, animated: true)
        case passwordTextField:
            scrollView.endEditing(true)
        default:
            break
        }
        return true
    }
}

extension UIScrollView {
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismissKeyboard(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
}
