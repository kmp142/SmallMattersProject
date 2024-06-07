//
//  ClassfieldsScreen.swift
//  SmallMattersProject
//
//  Created by Dmitry on 19.03.2024.
//

import Foundation
import UIKit
import SnapKit

enum CVSection {
    case main
}

protocol MainTapeViewDelegate: AnyObject {
    func didTapAddressButton()
    func updateCVDataSource()
    func filtersButtonTapped()
    func didSelectAd(ad: Ad)
}

    //TODO: - Replace button on view with tapGestureRecognizer

class MainTapeView: UIView {

    // MARK: - Properties

    private lazy var addressView: UIView = {
        let view = UIView()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapAddressView))
        view.addGestureRecognizer(tapGR)
        return view
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        return label
    }()

    private lazy var searchBar: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите название объявления"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration = .plain()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(openFiltersScreen), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshRequested), for: .valueChanged)
        return rc
    }()

    private lazy var adsCV: UICollectionView = configureAdsCV()

    private var dataSource: UICollectionViewDiffableDataSource<CVSection, Ad>?

    private weak var delegate: MainTapeViewDelegate?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        configureDataSource()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View configuration

    private func configureView() {
        addSubview(addressView)
        addressView.addSubview(addressLabel)
        addSubview(searchBar)
        addSubview(adsCV)
        addSubview(filtersButton)
        setupConstraints()
    }

    private func configureAdsCV() -> UICollectionView {
        let cv = UICollectionView(frame: .zero, 
                                  collectionViewLayout: configureCVFlowLayout())
        cv.register(AdCVCell.self, forCellWithReuseIdentifier: AdCVCell.reuseIdentifier)
        cv.refreshControl = refreshControl
        cv.delegate = self
        return cv
    }

    private func configureCVFlowLayout() -> UICollectionViewFlowLayout {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 1
        flow.minimumInteritemSpacing = 1
        flow.sectionInset = .zero
        flow.itemSize = CGSize(width: DeviceScreenParams.screenWidth, height: 88)
        return flow
    }

    private func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }

    private func setupConstraints() {
        addressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.height.equalTo(40)
        }

        addressLabel.snp.makeConstraints { make in
            make.left.right.centerY.equalToSuperview()
        }

        filtersButton.snp.makeConstraints { make in
            make.height.width.equalTo(16)
            make.centerY.equalTo(searchBar.snp.centerY)
            make.right.equalToSuperview().offset(-16)
        }

        searchBar.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.top.equalTo(addressView.snp.bottom).offset(4)
            make.right.equalTo(filtersButton.snp.left).offset(-12)
            make.height.equalTo(30)
        }

        adsCV.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(4)
        }
    }

    func setupDelegate(delegate: MainTapeViewDelegate) {
        self.delegate = delegate
    }

    //MARK: - DataSource

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CVSection, Ad>(collectionView: adsCV, cellProvider: {collectionView, indexPath, ad in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCVCell.reuseIdentifier, for: indexPath) as! AdCVCell
            cell.configureCell(with: ad)
            return cell
        })
    }

    func updateDataSource(newItems: [Ad]) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<CVSection, Ad>()
            snapshot.appendSections([CVSection.main])
            snapshot.appendItems(newItems, toSection: .main)
            self.dataSource?.apply(snapshot, animatingDifferences: true)
        }
    }

    func changeAddressNameLabel(with: String) {
        addressLabel.text = with
    }

    //MARK: - Objc targets

    @objc private func openFiltersScreen() {
        delegate?.filtersButtonTapped()
    }

    @objc private func didTapAddressView() {
        delegate?.didTapAddressButton()
    }

    @objc private func refreshRequested() {
        delegate?.updateCVDataSource()
        refreshControl.endRefreshing()
    }
}

extension MainTapeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let ad = dataSource?.itemIdentifier(for: indexPath) {
            delegate?.didSelectAd(ad: ad)
        }
    }
}

extension MainTapeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


