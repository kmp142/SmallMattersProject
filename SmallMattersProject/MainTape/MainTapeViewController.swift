//
//  ClassfieldsViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 19.03.2024.
//

import UIKit

protocol MainTapeViewControllerInterface: AnyObject {

}

class MainTapeViewController: UIViewController, MainTapeViewControllerInterface {

    private var mainTapeView = MainTapeView()
    private var viewModel: MainTapeViewModelInterface?

    override func loadView() {
        view = mainTapeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTapeView.setupDelegate(delegate: self)
        mainTapeView.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        updateDataSource()
    }

    init(viewModel: MainTapeViewModelInterface) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateDataSource() {
        if let viewModel = viewModel as? MainTapeViewModel {
            viewModel.$ads
                .compactMap{$0}
                .sink { [weak self] ads in
                    self?.mainTapeView.updateDataSource(newItems: ads)
                }.cancel()
        }
    }
}

extension MainTapeViewController: MainTapeViewDelegate {
    func didTapAddressButton() {
        let mapVM = MapViewModel()
        let mapVC = SelectLocationMapVC(viewModel: mapVM)
        let NC = UINavigationController(rootViewController: mapVC)
        NC.modalPresentationStyle = .fullScreen
        present(NC, animated: true)
    }
}
