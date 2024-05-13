//
//  ChatsListViewController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 24.03.2024.
//

import Foundation
import UIKit

protocol ChatsListViewControllerInterface {}

class ChatsListViewController: UIViewController, ChatsListViewControllerInterface {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
}
