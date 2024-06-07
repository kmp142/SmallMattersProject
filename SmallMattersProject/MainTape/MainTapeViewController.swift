//
//  ClassfieldsViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 19.03.2024.
//

import UIKit
import Combine

protocol MainTapeViewControllerInterface: AnyObject {
    
}

class MainTapeViewController: UIViewController, MainTapeViewControllerInterface {

    //MARK: - Properties

    private var mainTapeView = MainTapeView()
    private var viewModel: MainTapeViewModelInterface?
    private var subscriptions = Set<AnyCancellable>()

    //MARK: - Initialization

    init(viewModel: MainTapeViewModelInterface) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainTapeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTapeView.setupDelegate(delegate: self)
        createSubscriptionOnViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewModel?.fetchActiveUserLocation()
    }

    //MARK: - Binding

    private func createSubscriptionOnViewModel() {
        if let viewModel = viewModel as? MainTapeViewModel {
            
            viewModel.$adsWithUsers.sink { [weak self] adsWithUsers in
                let ads = Array(adsWithUsers.keys)
                self?.mainTapeView.updateDataSource(newItems: ads)
            }.store(in: &subscriptions)

            viewModel.$locationAddressName.sink { [weak self] addressName in
                if let address = addressName {
                    self?.mainTapeView.changeAddressNameLabel(with: address)
                } else {
                    self?.mainTapeView.changeAddressNameLabel(with: "Ваш адрес")
                }
            }.store(in: &subscriptions)
        }
    }
}

extension MainTapeViewController: MainTapeViewDelegate {

    func didSelectAd(ad: Ad) {
        let author = viewModel?.fetchAuthorForAd(ad: ad)
        guard let author = author else { return }
        let adDetailsVM = AdDetailsScreenViewModel(ad: ad, author: author, networkService: NetworkService())
        let adDetailsVC = AdDetailsViewController(viewModel: adDetailsVM)
        adDetailsVM.view = adDetailsVC
        navigationController?.pushViewController(adDetailsVC, animated: true)
    }

    func updateCVDataSource() {
        viewModel?.updateAllAds()
        viewModel?.fetchActiveUserLocation()
    }
    
    func didTapAddressButton() {
        let mapVM = MapViewModel()
        let mapVC = SelectLocationMapVC(viewModel: mapVM)
        let mapNC = UINavigationController(rootViewController: mapVC)
        mapNC.modalPresentationStyle = .fullScreen
        present(mapNC, animated: true)
    }

    func filtersButtonTapped() {
        if let viewModel = viewModel {
            let filtersVC = AdFiltersVC(viewModel: viewModel)
            let filtersNC = UINavigationController(rootViewController: filtersVC)
            filtersNC.modalPresentationStyle = .fullScreen
            present(filtersNC, animated: true)
        }

    }


}
