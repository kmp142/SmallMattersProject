//
//  AdFiltersVC.swift
//  SmallMattersProject
//
//  Created by Dmitry on 08.04.2024.
//

import Foundation
import UIKit

protocol AdFiltersVCInterface {

}

//TODO: Tie with viewModel

class AdFiltersVC: UIViewController, AdFiltersVCInterface {

    //MARK: - Properties

    private lazy var dismissScreenButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        button.imageView?.tintColor = .black
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Расстояние"
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()

    private lazy var distanceFromValueTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "От"
        tf.keyboardType = .numberPad
        return tf
    }()

    private lazy var distanceToValueTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "До"
        tf.keyboardType = .numberPad
        return tf
    }()

    private lazy var bountyLabel: UILabel = {
        let label = UILabel()
        label.text = "Вознаграждение"
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()

    private lazy var bountyFromTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "От"
        tf.keyboardType = .numberPad
        return tf
    }()

    private lazy var bountyToTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "До"
        tf.keyboardType = .numberPad
        return tf
    }()

    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Срок исполнения"
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()

    private lazy var deadlineSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "до 3 ч.", at: 0, animated: false)
        sc.insertSegment(withTitle: "от 3 до 24 ч.", at: 1, animated: false)
        sc.insertSegment(withTitle: "24 ч. и более", at: 2, animated: false)
        return sc
    }()

    private lazy var saveFiltersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.9583392739, blue: 0.3281950951, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(saveFiltersButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        return tapGR
    }()

    private let viewModel: MainTapeViewModelInterface?

    //MARK: - Initialization

    init(viewModel: MainTapeViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    //MARK: - View configuration

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(distanceLabel)
        view.addSubview(distanceFromValueTextField)
        view.addSubview(distanceToValueTextField)
        view.addSubview(bountyLabel)
        view.addSubview(bountyFromTextField)
        view.addSubview(bountyToTextField)
        view.addSubview(deadlineLabel)
        view.addSubview(deadlineSegmentedControl)
        view.addSubview(saveFiltersButton)
        view.addGestureRecognizer(tapGestureRecognizer)
        setupConstraints()
        configureNavigationBar()
    }

    private func setupConstraints() {

        distanceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(36)
        }

        distanceFromValueTextField.snp.makeConstraints { make in
            make.left.equalTo(distanceLabel.snp.left)
            make.top.equalTo(distanceLabel.snp.bottom).offset(4)
            make.right.equalTo(view.snp.centerX).offset(-8)
        }

        distanceToValueTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(8)
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(distanceLabel.snp.bottom).offset(4)
        }

        bountyLabel.snp.makeConstraints { make in
            make.top.equalTo(distanceFromValueTextField.snp.bottom).offset(24)
            make.left.equalTo(distanceLabel.snp.left)
        }

        bountyFromTextField.snp.makeConstraints { make in
            make.left.equalTo(distanceLabel.snp.left)
            make.right.equalTo(distanceFromValueTextField.snp.right)
            make.top.equalTo(bountyLabel.snp.bottom).offset(4)
        }

        bountyToTextField.snp.makeConstraints { make in
            make.left.equalTo(distanceToValueTextField.snp.left)
            make.top.equalTo(bountyLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(16)
        }

        deadlineLabel.snp.makeConstraints { make in
            make.left.equalTo(distanceLabel.snp.left)
            make.top.equalTo(bountyFromTextField.snp.bottom).offset(24)
        }

        deadlineSegmentedControl.snp.makeConstraints { make in
            make.left.equalTo(distanceLabel.snp.left)
            make.right.equalTo(bountyToTextField.snp.right)
            make.top.equalTo(deadlineLabel.snp.bottom).offset(4)
            make.height.equalTo(40)
        }

        saveFiltersButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.right.equalToSuperview().offset(-28)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private func configureNavigationBar() {
        title = "Установите фильтры"
        let dismissButton = UIBarButtonItem(barButtonSystemItem: .close,
                                         target: self,
                                         action: #selector(dismissButtonTapped))
        navigationItem.leftBarButtonItem = dismissButton
    }

    //MARK: - Objc targets

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    //TODO: save settings into viewModel
    @objc private func saveFiltersButtonTapped() {
        if let viewModel = viewModel as? MainTapeViewModel {
            let minimalBountyAmount = Double(bountyFromTextField.text ?? "0")
            let maximumBountyAmount = Double(bountyToTextField.text ?? "0")
            let minimalDistanceToUser = Double(distanceFromValueTextField.text ?? "0")
            let maximumDistanceToUser = Double(distanceToValueTextField.text ?? "0")
            var hoursToDeadline = 0...0
            switch deadlineSegmentedControl.selectedSegmentIndex {
            case 0:
                hoursToDeadline = 0...3
            case 1:
                hoursToDeadline = 3...24
            case 2:
                hoursToDeadline = 24...10000
            default:
                hoursToDeadline = 0...10000
            }

            viewModel.adsBountyRange = (minimalBountyAmount ?? 0)...(maximumBountyAmount ?? 0)
            viewModel.adsDistanceToUserRange = (minimalDistanceToUser ?? 0)...(maximumDistanceToUser ?? 0)
            viewModel.hoursToDeadline = hoursToDeadline
            viewModel.filterAds()
        }
        dismiss(animated: true)
    }

    @objc private func viewTapped() {
        view.endEditing(true)
    }

}



