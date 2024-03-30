//
//  ViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 17.03.2024.
//

import UIKit

class AuthViewController: UIViewController {

    var authView = AuthenticationView()
    var viewModel = AuthViewModel()

    override func loadView() {
        view = authView
        authView.setupViewModel(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

