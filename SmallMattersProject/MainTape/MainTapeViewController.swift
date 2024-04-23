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

    //MARK: - Binding

    private func createSubscriptionOnViewModel() {
        if let viewModel = viewModel as? MainTapeViewModel {
            viewModel.$ads.sink { [weak self] ads in
                self?.mainTapeView.updateDataSource(newItems: ads)
            }.store(in: &subscriptions)
        }
    }
}

extension MainTapeViewController: MainTapeViewDelegate {

    func updateCVDataSource() {
        viewModel?.updateAllAds()
    }
    
    func didTapAddressButton() {
        let mapVM = MapViewModel()
        let mapVC = SelectLocationMapVC(viewModel: mapVM)
        let mapNC = UINavigationController(rootViewController: mapVC)
        mapNC.modalPresentationStyle = .fullScreen
        present(mapNC, animated: true)
    }

    func filtersButtonTapped() {
        let filtersVC = AdFiltersVC()
        let filtersNC = UINavigationController(rootViewController: filtersVC)
        filtersNC.modalPresentationStyle = .fullScreen
        present(filtersNC, animated: true)
    }
}
