//
//  AddAdVC.swift
//  SmallMattersProject
//
//  Created by Dmitry on 06.05.2024.
//

import Foundation
import UIKit

class AddAdVC: UIViewController {

    //MARK: - Properties

    private lazy var enterAdNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите название объявления:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var adNameTextField: UITextView = {
        let tf = UITextView()
        tf.layer.cornerRadius = 10
        tf.font = .systemFont(ofSize: 20)
        tf.backgroundColor = .systemGray6
        return tf
    }()

    private lazy var enterAdDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите описание объявления:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var adDescriptionTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 20)
        tv.backgroundColor = .systemGray6
        return tv
    }()


    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
//        sv.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 120)
        return sv
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Веберите адрес:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()

    private lazy var addressTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 20)
        tv.backgroundColor = .systemGray6
        tv.isScrollEnabled = false
        return tv
    }()


    //MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        view.backgroundColor = .white
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(scrollView)
        scrollView.addSubview(adNameTextField)
        scrollView.addSubview(enterAdNameLabel)
        scrollView.addSubview(enterAdDescriptionLabel)
        scrollView.addSubview(adDescriptionTextView)
        scrollView.addSubview(addressLabel)
        scrollView.addSubview(addressTextView)
        setupConstraints()
    }

    private func setupConstraints() {

        scrollView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

        enterAdNameLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
        }

        adNameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
            make.top.equalTo(enterAdNameLabel.snp.bottom).offset(8)
        }

        enterAdDescriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(adNameTextField.snp.bottom).offset(8)
        }

        adDescriptionTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(252)
            make.top.equalTo(enterAdDescriptionLabel.snp.bottom).offset(8)
        }

        addressLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(adDescriptionTextView.snp.bottom)
        }

        addressTextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
    }

    private func configureNavigationBar() {
        title = "Новое объявление"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }

    //MARK: - Objc targets

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
