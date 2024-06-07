
import Foundation
import UIKit

protocol AdsListViewControllerInterface: AnyObject {
    func updateDataSource(with ads: [Ad])
    func updateView(isActiveUserExist: Bool)
}


class AdsListViewController: UIViewController, AdsListViewControllerInterface {

    private enum CVSections {
        case main
    }

    //MARK: - Properties

    private lazy var addAdView: UIView = {
        let view = UIView()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(addAdViewTapped))
        view.addGestureRecognizer(tapGR)
        view.backgroundColor = .systemCyan
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var addAdLabel: UILabel = {
        let label = UILabel()
        label.text = "Новое объявление"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()

    private lazy var categoriesSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "Опубликовал", at: 0, animated: false)
        sc.insertSegment(withTitle: "Откликнулся", at: 1, animated: false)
        sc.addTarget(self, action: #selector(SCIndexChanged), for: .valueChanged)
        return sc
    }()

    private lazy var adsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: configureCVFlowLayout())
        cv.register(AdCVCell.self, forCellWithReuseIdentifier: AdCVCell.reuseIdentifier)
        cv.refreshControl = CVRefreshControl
        cv.delegate = self
        return cv
    }()

    private lazy var CVRefreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshCVRequested), for: .valueChanged)
        return rc
    }()

    private var dataSource: UICollectionViewDiffableDataSource<CVSections, Ad>?

    private var viewModel: AdsListViewModelInterface?

    //MARK: - Initialization

    init(viewModel: AdsListViewModelInterface) {
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
    }

    //MARK: - View configuration

    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(categoriesSegmentedControl)
        view.addSubview(adsCollectionView)
        view.addSubview(addAdView)
        addAdView.addSubview(addAdLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        addAdView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-100)
        }

        addAdLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        categoriesSegmentedControl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            make.centerX.equalToSuperview()
        }

        adsCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(categoriesSegmentedControl.snp.bottom)
            make.bottom.equalToSuperview()
        }
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

    //MARK: - Data source

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<CVSections, Ad>(collectionView: adsCollectionView, cellProvider: { [weak self] collectionView, indexPath, ad in
            let cell = self?.adsCollectionView.dequeueReusableCell(withReuseIdentifier: AdCVCell.reuseIdentifier, for: indexPath) as! AdCVCell
            cell.configureCell(with: ad)
            return cell
        })
    }

    func updateDataSource(with ads: [Ad]) {
        DispatchQueue.main.async { [weak self] in
            var snapshot = NSDiffableDataSourceSnapshot<CVSections, Ad>()
            snapshot.appendSections([.main])
            snapshot.appendItems(ads, toSection: .main)
            self?.dataSource?.apply(snapshot)
        }
    }

    //MARK: Interface implementation

    func updateView(isActiveUserExist: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isActiveUserExist {
                self?.categoriesSegmentedControl.isHidden = false
            } else {
                self?.categoriesSegmentedControl.isHidden = true
            }
        }
    }

    //MARK: - Objc targets

    @objc private func addAdViewTapped() {
        let user = AuthManager.shared.activeUser

        if let latitude = user?.locationLatitude, let longitude = user?.locationLongitude {
            let networkService = NetworkService()
            let user = AuthManager.shared.activeUser
            let viewModel = AddAdViewModel(activeUser: user, activeUserLocation: Location(latitude: latitude, longitude: longitude), networkService: networkService)
            let addAdVC = AddAdVC(viewModel: viewModel)
            viewModel.view = addAdVC
            addAdVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(addAdVC, animated: true)
        } else {
            let alertController = UIAlertController(title: "Авторизация", message: "Пожалуйста, авторизуйтесь перед публикацией объявлений", preferredStyle: .alert)
            let action = UIAlertAction(title: "Отмена", style: .cancel)
            alertController.addAction(action)
            present(alertController, animated: true)
        }
    }

    @objc private func SCIndexChanged() {
        switch categoriesSegmentedControl.selectedSegmentIndex {
        case 0:
            viewModel?.updatePublishedAds()
        case 1:
            viewModel?.updateRespondedAds()
        default:
            break
        }
    }

    @objc private func refreshCVRequested() {
        switch categoriesSegmentedControl.selectedSegmentIndex {
        case 0:
            viewModel?.updatePublishedAds()
        case 1:
            viewModel?.updateRespondedAds()
        default:
            break
        }
        CVRefreshControl.endRefreshing()
    }
}

extension AdsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ad = dataSource?.itemIdentifier(for: indexPath) as? Ad
        guard let ad = ad else { return }
        let author = viewModel?.fetchAuthorForAd(ad: ad)
        guard let author = author else { return }
        let adDetailsVM = AdDetailsScreenViewModel(ad: ad, author: author, networkService: NetworkService())
        let adDetailsVC = AdDetailsViewController(viewModel: adDetailsVM)
        adDetailsVM.view = adDetailsVC
        navigationController?.pushViewController(adDetailsVC, animated: true)
    }
}
