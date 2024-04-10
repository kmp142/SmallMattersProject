//
//  TabBarController.swift
//  SmallMattersProject
//
//  Created by Dmitry on 19.03.2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func addViewControllers(viewControllers: UIViewController...) {
        setViewControllers(viewControllers, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

