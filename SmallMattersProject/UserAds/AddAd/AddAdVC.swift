//
//  AddAdVC.swift
//  SmallMattersProject
//
//  Created by Dmitry on 06.05.2024.
//

import Foundation
import UIKit
import SwiftUI

protocol AddAdVCInterface: AnyObject {
    func adLocationSaved()
    func setAddressName(addressName: String?)
}

class AddAdVC: UIViewController, AddAdVCInterface {
    
    //MARK: - Properties
    
    private lazy var enterAdNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Введите название объявления:"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var adNameTextView: UITextView = {
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
    
    private lazy var contentViewTapGR: UITapGestureRecognizer = {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(contentViewTapped))
        return tapGR
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.isScrollEnabled = true
        
        sv.addGestureRecognizer(contentViewTapGR)
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
        tv.font = .systemFont(ofSize: 17)
        tv.backgroundColor = .systemGray6
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        sv.spacing = 10
        return sv
    }()
    
    private lazy var selectAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.configuration = .bordered()
        button.addTarget(self, action: #selector(selectLocationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectAddressStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.addArrangedSubview(addressTextView)
        sv.addArrangedSubview(selectAddressButton)
        sv.spacing = 8
        return sv
    }()
    
    private lazy var deadlineDatePicker: UIDatePicker = {
        let dp = UIDatePicker()
        return dp
    }()
    
    private lazy var deadlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Дедлайн: "
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var deadlineStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(deadlineLabel)
        sv.addArrangedSubview(deadlineDatePicker)
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private lazy var minimalExecutorRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Рейтинг больше  "
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var minimalExectorRatingSC: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "1", at: 0, animated: false)
        sc.insertSegment(withTitle: "2", at: 1, animated: false)
        sc.insertSegment(withTitle: "3", at: 2, animated: false)
        sc.insertSegment(withTitle: "4", at: 3, animated: false)
        sc.insertSegment(withTitle: "5", at: 4, animated: false)
        return sc
    }()
    
    private lazy var minimalExecutorRatingStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(minimalExecutorRatingLabel)
        sv.addArrangedSubview(minimalExectorRatingSC)
        return sv
    }()
    
    private lazy var publicAdButton: UIButton = {
        let button = UIButton()
        button.setTitle("Опубликовать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        button.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(publicAdButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var bountyLabel: UILabel = {
        let label = UILabel()
        label.text = "Вознаграждение: "
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private lazy var bountyTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 17)
        tv.backgroundColor = .systemGray6
        tv.isScrollEnabled = false
        tv.keyboardType = .numberPad
        return tv
    }()
    
    private lazy var bountyStackView: UIStackView = {
        let sv = UIStackView()
        sv.addArrangedSubview(bountyLabel)
        sv.addArrangedSubview(bountyTextView)
        sv.axis = .horizontal
        return sv
    }()
    
    private let viewModel: AddAdViewModelInterface?
    
    //MARK: - Initialization
    
    init(viewModel: AddAdViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - View configuration
    
    private func configureView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        
        contentStackView.addArrangedSubview(enterAdNameLabel)
        contentStackView.addArrangedSubview(adNameTextView)
        contentStackView.addArrangedSubview(enterAdDescriptionLabel)
        contentStackView.addArrangedSubview(adDescriptionTextView)
        contentStackView.addArrangedSubview(addressLabel)
        contentStackView.addArrangedSubview(selectAddressStackView)
        contentStackView.addArrangedSubview(deadlineStackView)
        contentStackView.addArrangedSubview(minimalExecutorRatingStackView)
        contentStackView.addArrangedSubview(bountyStackView)
        contentStackView.addArrangedSubview(publicAdButton)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        enterAdNameLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
        
        adNameTextView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        enterAdDescriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
        
        adDescriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(252)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
        
        selectAddressStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        addressTextView.snp.makeConstraints { make in
            make.width.equalTo(selectAddressStackView.snp.width).multipliedBy(0.70)
        }
        
        selectAddressButton.snp.makeConstraints { make in
            make.width.equalTo(selectAddressStackView.snp.width).multipliedBy(0.28)
        }
        
        deadlineStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        minimalExecutorRatingStackView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        publicAdButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        bountyStackView.snp.makeConstraints { make in
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
    
    //MARK: Protocol implementation

    func adLocationSaved() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func setAddressName(addressName: String?) {
        self.addressTextView.text = addressName
    }
    
    //MARK: - Objc targets
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func contentViewTapped() {
        scrollView.endEditing(true)
    }
    
    @objc private func selectLocationButtonTapped() {
        if let viewModel = viewModel as? SelectLocationMapViewModelInterface {
            let selectLocationVC = SelectLocationMapVC(viewModel: viewModel)
            let selectLocationNC = UINavigationController(rootViewController: selectLocationVC)
            selectLocationNC.modalPresentationStyle = .fullScreen
            present(selectLocationNC, animated: true)
        }
    }
    
    @objc private func publicAdButtonTapped() {
        if adNameTextView.text.trimmingCharacters(in: .whitespaces) != "",
           adDescriptionTextView.text.trimmingCharacters(in: .whitespaces) != "" {
            Task {
                await viewModel?.publicAd(title: adNameTextView.text, description: adDescriptionTextView.text, deadline: deadlineDatePicker.date, minimalExecutorRating: minimalExectorRatingSC.selectedSegmentIndex + 1, bounty: Double(bountyTextView.text) ?? 0)
            }

        }
        navigationController?.popViewController(animated: true)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 40, right: 0)
                scrollView.contentInset = contentInsets
                scrollView.scrollIndicatorInsets = contentInsets

                var viewRect = self.view.frame
                viewRect.size.height -= keyboardSize.height

                if !viewRect.contains(bountyTextView.frame.origin) {
                    scrollView.scrollRectToVisible(bountyTextView.frame, animated: true)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

struct ViewControllerProvider: PreviewProvider {
    static var previews: some View {
        let userLocationLatitude = AuthManager.shared.activeUser?.locationLatitude
        let userLocationLongitude = AuthManager.shared.activeUser?.locationLongitude
        if let latitude = userLocationLatitude, let longitude = userLocationLongitude {
            let user = AuthManager.shared.activeUser
            let viewModel = AddAdViewModel(activeUser: user, activeUserLocation: Location(latitude: latitude, longitude: longitude), networkService: NetworkService())
            AddAdVC(viewModel: viewModel).showPreview()
        }
    }
}
