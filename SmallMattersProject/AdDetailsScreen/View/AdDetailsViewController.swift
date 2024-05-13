//
//  AdDetailsViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 29.04.2024.
//

import UIKit
import Combine

enum AdDetailsCVSection: Hashable, CaseIterable {
    case adName
    case adDescription
    case adSpecification
    case adAuthorProfile
    case adCommunicationWithAuthor
    case respondToAd
}

enum AdDetailsCVItem: Hashable {
    case adName(String)
    case adDescription(String)
    case adSpecification(Ad)
    case adAuthorProfile(User)
    case adCommunicationWithAuthor(User)
    case respondToAd
}

class AdDetailsViewController: UIViewController {

    //MARK: - Properties

    private lazy var collectionView: UICollectionView = configureCV()

    private lazy var respondToAdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.text = "Откликнуться"
        return label
    }()

    private var dataSource: UICollectionViewDiffableDataSource<AdDetailsCVSection, AdDetailsCVItem>?

    private var viewModel: AdDetailsScreenViewModelInterface?

    private var subscriptionOnAd: AnyCancellable?

    //MARK: - Initialization

    init(viewModel: AdDetailsScreenViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureDataSource()
        configureNavigationBar()
        if let viewModel = viewModel as? AdDetailsScreenViewModel {
            configureDataSource(with: viewModel.ad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    //MARK: - View configuration

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func configureNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }

    private func configureCV() -> UICollectionView {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createCVLayout())

        cv.register(AdNameCVCell.self, forCellWithReuseIdentifier: AdNameCVCell.reuseIdentifier)
        cv.register(AdDescriptionCVCell.self, forCellWithReuseIdentifier: AdDescriptionCVCell.reuseIdentifier)

        cv.register(AdSpecificationsCVCell.self, forCellWithReuseIdentifier: AdSpecificationsCVCell.reuseIdentifier)

        cv.register(AdAuthorProfileCVCell.self, forCellWithReuseIdentifier: AdAuthorProfileCVCell.reuseIdentifier)

        cv.register(AdCommunicationWithAuthorCVCell.self, forCellWithReuseIdentifier: AdCommunicationWithAuthorCVCell.reuseIdentifier)

        cv.register(RespondToAdCVCell.self, forCellWithReuseIdentifier: RespondToAdCVCell.reuseIdentifier)

        cv.register(AdDescriptionSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AdDescriptionSupplementaryView.reuseIdentifire)

        cv.register(AdSpecificationsSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AdSpecificationsSupplementaryView.reuseIdentifire)

        cv.showsVerticalScrollIndicator.toggle()
        return cv
    }

    //MARK: Data source

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            switch item {
            case .adName(let name):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdNameCVCell.reuseIdentifier, for: indexPath) as! AdNameCVCell
                cell.configureCell(with: name)
                return cell
            case .adDescription(let description):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdDescriptionCVCell.reuseIdentifier, for: indexPath) as! AdDescriptionCVCell
                cell.configureCell(with: description)
                return cell
            case .adSpecification(let ad):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdSpecificationsCVCell.reuseIdentifier, for: indexPath) as! AdSpecificationsCVCell
                cell.configureCell(with: ad)
                cell.setupDelegate(self)
                return cell
            case .adAuthorProfile(let user):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdAuthorProfileCVCell.reuseIdentifier, for: indexPath) as! AdAuthorProfileCVCell
                cell.configureCell(user: user)
                cell.setupDelegate(self)
                return cell
            case .adCommunicationWithAuthor(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCommunicationWithAuthorCVCell.reuseIdentifier, for: indexPath) as! AdCommunicationWithAuthorCVCell
                cell.setupDelegate(self)
                return cell
            case .respondToAd:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RespondToAdCVCell.reuseIdentifier, for: indexPath) as! RespondToAdCVCell
                cell.setupDelegate(self)
                return cell
            }
        })

        dataSource?.supplementaryViewProvider = {collectionView, kind, indexPath in
            if kind == UICollectionView.elementKindSectionHeader {
                switch indexPath.section {
                case 1: 
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AdDescriptionSupplementaryView.reuseIdentifire, for: indexPath) as! AdDescriptionSupplementaryView
                    return headerView
                case 2:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AdSpecificationsSupplementaryView.reuseIdentifire, for: indexPath)
                    return headerView
                default:
                    break
                }
            }
            return UICollectionReusableView(frame: .zero)
        }
    }

    func configureDataSource(with ad: Ad) {
        var snapshot = NSDiffableDataSourceSnapshot<AdDetailsCVSection, AdDetailsCVItem>()
        AdDetailsCVSection.allCases.forEach { section in
                snapshot.appendSections([section])
        }
        let adName = AdDetailsCVItem.adName(ad.name)
        let adDescription = AdDetailsCVItem.adDescription(ad.description)
        let adSpecifications = AdDetailsCVItem.adSpecification(ad)
        let adAuthorProfile = AdDetailsCVItem.adAuthorProfile(ad.author)
        let adCommunicationWithAuthor = AdDetailsCVItem.adCommunicationWithAuthor(ad.author)
        let respondToAd = AdDetailsCVItem.respondToAd
        snapshot.appendItems([adName], toSection: .adName)
        snapshot.appendItems([adDescription], toSection: .adDescription)
        snapshot.appendItems([adSpecifications], toSection: .adSpecification)
        snapshot.appendItems([adAuthorProfile], toSection: .adAuthorProfile)
        snapshot.appendItems([adCommunicationWithAuthor], toSection: .adCommunicationWithAuthor)
        snapshot.appendItems([respondToAd], toSection: .respondToAd)
        dataSource?.apply(snapshot)
    }

    //MARK: Compositional layout

    private func createCVLayout() -> UICollectionViewLayout {

        let adNameSection = createAdNameSection()
        let adDescriptionSection = createAdDescriptionSection()
        let adSpecificationSection = createAdSpecificationSection()
        let adAuthorProfileSection = createAdAuthorProfileSection()
        let adCommunicationWithAuthorSection = createAdCommunicationWithAuthorSection()
        let respondToAdSection = createRespondToAdSection()

        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, _ in
            switch sectionIndex {
            case 0:
                return adNameSection
            case 1:
                return adDescriptionSection
            case 2:
                return adSpecificationSection
            case 3:
                return adAuthorProfileSection
            case 4:
                return adCommunicationWithAuthorSection
            case 5:
                return respondToAdSection
            default:
                return nil
            }
        }, configuration: layoutConfig)

        return layout
    }

    private func createAdNameSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        return section
    }

    private func createAdDescriptionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                             subitems: [item])
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]

        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        return section
    }

    private func createAdSpecificationSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        return section
    }

    private func createAdAuthorProfileSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        return section
    }

    private func createAdCommunicationWithAuthorSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(52))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(52))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)

        return section
    }

    private func createRespondToAdSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)

        return section
    }

    //MARK: - Objc targets

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension AdDetailsViewController: AdSpecificationsCVCellDelegate {
    func showAdOnMap() {
        if let viewModel = viewModel as? AdDetailsScreenViewModel {
            let adOnMapVC = AdOnMapVC(ad: viewModel.ad)
            let adOnMapNC = UINavigationController(rootViewController: adOnMapVC)
            adOnMapNC.modalPresentationStyle = .fullScreen
            present(adOnMapNC, animated: true)
        }
    }
}

extension AdDetailsViewController: AdCommunicationWithAuthorCVCellDelegate {

    func callPressed() {
        if let url = URL(string: "tel://+79373953301") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func messagePressed() {
        print("message pressed")
    }
}

extension AdDetailsViewController: RespondToAdCVCellDelegate {

}

extension AdDetailsViewController: AdAuthorProfileCVCellDelegate {
    func pressedOnProfileView() {
        if let viewModel = viewModel as? AdDetailsScreenViewModel {
            let profileVM = ProfileViewModel(user: nil)
            let profileVC = ProfileViewController(viewModel: profileVM)
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}
