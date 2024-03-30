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

class MainTapeView: UIView, UICollectionViewDelegate {

    // MARK: - Properties

    private lazy var addressButton: UIButton = {
        configureAddressButton()
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Введите название объявления"
        searchBar.searchBarStyle = .minimal
        return searchBar
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

    private lazy var classfieldsCV: UICollectionView = {
        configureClassfieldsCV()
    }()

    private var dataSource: UICollectionViewDiffableDataSource<CVSection, Ad>?

    private weak var controller: MainTapeViewControllerInterface?

    let leftIndent: CGFloat = DeviceScreenParams.screenWidth * 0.02

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureDataSource()

        addSubviews(addressButton, searchBar, classfieldsCV)
        setupConstraints()
        var classfields = [Ad]()
        for _ in 0...30 {
            classfields.append(Ad())
        }
        updateDataSource(newItems: classfields)
        print(Int(0.02))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupController(controller: MainTapeViewControllerInterface) {
        self.controller = controller
    }

    // MARK: - UI configuration

    private func configureAddressButton() -> UIButton {
        let button = UIButton()
        button.setTitle("ул. Пушкина, 32", for: .normal)
        button.configuration = .borderless()
        button.configuration?.titleTextAttributesTransformer =
           UIConfigurationTextAttributesTransformer { incoming in
             var outgoing = incoming
               outgoing.font = UIFont.systemFont(ofSize: 25, weight: .bold)
             return outgoing
         }
        let color = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color, for: .highlighted)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(addressButtonTapped), for: .touchUpInside)
        return button
    }

    private func configureClassfieldsCV() -> UICollectionView {
        let cv = UICollectionView(frame: .zero, 
                                  collectionViewLayout: configureCVFlowLayout())
        cv.register(ClassifiedCVCell.self, forCellWithReuseIdentifier: ClassifiedCVCell.reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }

    private func configureCVFlowLayout() -> UICollectionViewFlowLayout {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 1
        flow.minimumInteritemSpacing = 1
        flow.sectionInset = .zero
        flow.itemSize = CGSize(width: DeviceScreenParams.screenWidth, height: 120)
        return flow
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CVSection, Ad>(collectionView: classfieldsCV, cellProvider: {collectionView,indexPath,itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClassifiedCVCell.reuseIdentifier, for: indexPath) as! ClassifiedCVCell
            cell.configureCell(with: (self.dataSource?.itemIdentifier(for: indexPath))!)
            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<CVSection, Ad>()
        snapshot.appendSections([CVSection.main])
        snapshot.appendItems([Ad()], toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func updateDataSource(newItems: [Ad]) {
        var snapshot = NSDiffableDataSourceSnapshot<CVSection, Ad>()
        snapshot.appendSections([CVSection.main])
        snapshot.appendItems(newItems, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func addSubviews(_ subviews: UIView...) {
        searchBar.addSubview(filtersButton)
        subviews.forEach { addSubview($0) }
    }

    private func setupConstraints() {

        addressButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftIndent)
            make.right.equalToSuperview().inset(leftIndent)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(30)
        }

        searchBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(leftIndent)
            make.top.equalTo(addressButton.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        filtersButton.snp.makeConstraints { make in
            make.height.width.equalTo(searchBar.snp.height)
            make.centerY.equalToSuperview()
            make.right.equalTo(searchBar.snp.right).inset(10)

        }

        classfieldsCV.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(15)
        }
    }

    @objc private func openFiltersScreen() {
        print("openFiltersScreen button tapped")
    }

    @objc private func addressButtonTapped() {
        controller?.showMapAddressSelection()
    }
}

extension MainTapeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension MainTapeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
