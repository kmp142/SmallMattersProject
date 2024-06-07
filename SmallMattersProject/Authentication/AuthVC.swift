//
//  ViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 17.03.2024.
//

import UIKit

protocol AuthVCInterface: AnyObject {
    func backToMainTabBar()
    func showLoginFailure()
}

    //TODO: - Handle auth failure

class AuthVC: UIViewController, AuthVCInterface {

    //MARK: - Properties

    private var viewModel: AuthViewModelInterface?

    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: DeviceScreenParams.screenWidth, height: DeviceScreenParams.screenHeight + 10)
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        return sv
    }()

    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите email"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var credentialsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        return imageView
    }()

    private lazy var invalidCredentialsView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemRed
        view.backgroundColor = view.backgroundColor?.withAlphaComponent(0.4)
        view.isHidden = true
        return view

    }()

    private lazy var invalidCredentialLabel: UILabel = {
        let label = UILabel()
        label.text = "Неверные данные"
        label.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        label.alpha = 1
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.configuration = .bordered()
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var registrationButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.setTitle("Регистрация", for: .normal)
        return button
    }()

    private lazy var gesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()

    //MARK: - Initialization

    init(viewModel: AuthViewModelInterface) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        configureNavigationBar()
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(scrollView)
        invalidCredentialsView.addSubview(invalidCredentialLabel)
        addSubviewsToScrollView(subviews: logoImageView, credentialsStackView, loginButton, registrationButton, invalidCredentialsView)
        scrollView.addTapGestureToDismissKeyboard()

        setupConstraints()
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

        invalidCredentialsView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.bottom.equalTo(credentialsStackView.snp.top).offset(-8)
            make.width.equalTo(credentialsStackView.snp.width)
            make.centerX.equalToSuperview()
        }

        invalidCredentialLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
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

    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .close,
                                         target: self,
                                         action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    private func addSubviewsToScrollView(subviews: UIView...) {
        subviews.forEach { scrollView.addSubview($0) }
    }

    func backToMainTabBar() {
        invalidCredentialsView.isHidden = true
        dismiss(animated: true)
    }

    func showLoginFailure() {
        invalidCredentialsView.isHidden = false
    }

    //MARK: - Objc targets

    @objc private func loginButtonTapped() {
        viewModel?.login(login: loginTextField.text ?? "", password: passwordTextField.text ?? "")
    }

    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }

}

extension AuthVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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


