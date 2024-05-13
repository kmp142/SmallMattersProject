//
//  ProfileViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 24.03.2024.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

enum ProfileCVSection: Hashable {
    case review
    case profile

    var title: String {
        switch self {
        case .review:
            return "Отзывы"
        default:
            return ""
        }
    }
}

enum ProfileCVItem: Hashable {
    case user(user: User)
    case review(review: Review)
}

//TODO: - Tie with viewModel

class ProfileViewController: UIViewController {

    //MARK: - Properties

    private lazy var profileAndReviewsCV = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.register(ReviewCVCell.self, forCellWithReuseIdentifier: ReviewCVCell.reuseIdentifier)
        cv.register(ProfileCVCell.self, forCellWithReuseIdentifier: ProfileCVCell.reuseIdentifier)
        cv.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:  HeaderSupplementaryView.reuseIdentifire)
        return cv
    }()

    private lazy var logInLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.text = "Войти"
        return label
    }()

    private lazy var logInView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemCyan
        view.isHidden = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(logInViewTapped))
        view.addGestureRecognizer(tapGR)
        return view
    }()

    private var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()

    private var dataSource: UICollectionViewDiffableDataSource<ProfileCVSection, ProfileCVItem>?

    private var viewModel: ProfileViewModelInterface?

    //MARK: - Initialization

    init(viewModel: ProfileViewModelInterface?) {
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
        configureDataSource()
        if let viewModel = viewModel as? ProfileViewModel, let user = viewModel.user {
            updateDataSource(user: user)
            logInView.isHidden = true
        } else {
            logInView.isHidden = false
        }
        configureNavigationBar()
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(profileAndReviewsCV)
        view.addSubview(logInView)
        logInView.addSubview(logInLabel)
        setupConstraints()
        imagePicker.delegate = self
    }

    private func setupConstraints() {
        profileAndReviewsCV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }

        logInView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-100)
        }

        logInLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: nil)
        backButton.primaryAction = UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        backButton.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.leftBarButtonItem = backButton
    }

    //MARK: - DataSource

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ProfileCVSection, ProfileCVItem>(collectionView: profileAndReviewsCV, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .review(let review):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCVCell.reuseIdentifier, for: indexPath) as! ReviewCVCell
                cell.configureCell(with: review)
                return cell

            case .user(let user):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCVCell.reuseIdentifier, for: indexPath) as! ProfileCVCell
                cell.configureCell(with: user)
                cell.delegate = self
                return cell
            }
        })

        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.reuseIdentifire, for: indexPath) as! HeaderSupplementaryView
                let title = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section].title
                headerView.configureView(headerName:  title ?? "")
                return headerView
            }
            return UICollectionReusableView(frame: .zero)
        }
    }

    private func updateDataSource(user: User) {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileCVSection, ProfileCVItem>()
        snapshot.appendSections([.profile, .review])
        snapshot.appendItems([ProfileCVItem.user(user: user)], toSection: .profile)
        let reviewCVItems = user.reviews.map{ ProfileCVItem.review(review: $0)}
        snapshot.appendItems(reviewCVItems, toSection: .review)
        dataSource?.apply(snapshot)
    }

    //MARK: - CollectionView compositionalLayout

    func createLayout() -> UICollectionViewLayout {

        let profileSection = createProfileSection()
        let reviewsSection = createReviewsSection()

        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return profileSection
            case 1:
                return reviewsSection
            default:
                return nil
            }
        }, configuration: layoutConfig)

        return layout
    }

    func createProfileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: -16)

        return section
    }

    func createReviewsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]

        return section
    }

    //MARK: Objc targets

    @objc private func logInViewTapped() {
        let firebaseAuthManager = AuthManager()
        let authVM = AuthViewModel(authManager: firebaseAuthManager)
        let authVC = AuthVC(viewModel: authVM)
        present(authVC, animated: true)
    }
}

extension ProfileViewController: ProfileCVCellDelegate {
    func userAvatarImageTapped() {
        present(imagePicker, animated: true)
    }
}

//TODO: - Save photo into user inside viewModel

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let _ = info[.originalImage] as? UIImage {
            
        }
        dismiss(animated: true)
    }
}


