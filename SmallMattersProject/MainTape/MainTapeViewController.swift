//
//  ClassfieldsViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 19.03.2024.
//

import UIKit

protocol MainTapeViewControllerInterface: AnyObject {
    func showMapAddressSelection()
}

class MainTapeViewController: UIViewController, MainTapeViewControllerInterface {

    private var classFieldsView = MainTapeView()

    override func loadView() {
        view = classFieldsView
        classFieldsView.setupController(controller: self)
        classFieldsView.backgroundColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showMapAddressSelection() {
        let mapVM = MapViewModel()
        let mapVC = MapViewController(viewModel: mapVM)
        let NC = UINavigationController(rootViewController: mapVC)
        NC.modalPresentationStyle = .fullScreen
        present(NC, animated: true)
    }
}
