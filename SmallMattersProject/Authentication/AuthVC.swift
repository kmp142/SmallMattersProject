//
//  ViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 17.03.2024.
//

import UIKit

protocol AuthVCInterface: AnyObject {
    func crossToMainTabBar()
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
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(scrollView)
        addSubviewsToScrollView(subviews: logoImageView, credentialsStackView, loginButton, registrationButton)
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

    func crossToMainTabBar() {
        let tabBarController = TabBarAssembly().configureTabBar()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }

    func showLoginFailure() {
        print("login failed")
    }

    //MARK: - Objc targets

    @objc private func loginButtonTapped() {
        viewModel?.login(login: loginTextField.text ?? "", password: passwordTextField.text ?? "")
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


