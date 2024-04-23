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

enum CVItem: Hashable {
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
        cv.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: HeaderSupplementaryView.self))
        return cv
    }()

    private var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()

    private var dataSource: UICollectionViewDiffableDataSource<ProfileCVSection, CVItem>?

    //MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        configureDataSource()
        updateDataSource(reviews: [Review(),
                                    Review(),
                                    Review(),
                                    Review()
                                  ],
                         user: User())
    }

    //MARK: - View configuration

    private func configureView() {
        view.addSubview(profileAndReviewsCV)
        setupConstraints()
        imagePicker.delegate = self
    }

    private func setupConstraints() {
        profileAndReviewsCV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }

    //MARK: - DataSource

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ProfileCVSection, CVItem>(collectionView: profileAndReviewsCV, cellProvider: { collectionView, indexPath, item in
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
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderSupplementaryView", for: indexPath) as! HeaderSupplementaryView
                let title = self?.dataSource?.snapshot().sectionIdentifiers[indexPath.section].title
                headerView.configureView(headerName:  title ?? "")
                return headerView
            }
            return UICollectionReusableView(frame: .zero)
        }
    }

    func updateDataSource(reviews: [Review], user: User) {
        var snapshot = NSDiffableDataSourceSnapshot<ProfileCVSection, CVItem>()
        snapshot.appendSections([.profile, .review])
        let reviewsCVItems = reviews.map{ CVItem.review(review: $0)}
        snapshot.appendItems(reviewsCVItems, toSection: .review)
        snapshot.appendItems([CVItem.user(user: user)], toSection: .profile)
        dataSource?.apply(snapshot)
    }

    //MARK: - CollectionView compositionalLayout

    func createLayout() -> UICollectionViewLayout {

        let profileSection = createProfileSection()
        let reviewsSection = createReviewsSection()

        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, environment in
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
}

extension ProfileViewController: ProfileCVCellDelegate {
    func userAvatarImageTapped() {
        present(imagePicker, animated: true)
    }
}

//TODO: - Save photo into user inside viewModel

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            
        }
        dismiss(animated: true)
    }
}


