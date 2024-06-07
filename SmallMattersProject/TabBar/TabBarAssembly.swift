//
//  TabBarAssembly.swift
//  SmallMattersProject
//
//  Created by Dmitry on 25.03.2024.
//

import Foundation
import UIKit

class TabBarAssembly {

    let userRepository = UserRepository(context: PersistentContainer.shared.viewContext)

    func configureTabBar() -> UITabBarController {
        let tabBar = TabBarController()

        let mainTapeVM = MainTapeViewModel(networkService: NetworkService(), searchInteractor: YandexMapsAddressSearchInteractor())
        let mainTapeVC = MainTapeViewController(viewModel: mainTapeVM)
        let mainTapeNC = UINavigationController(rootViewController: mainTapeVC)
        mainTapeVC.title = "Лента"


        let mapWithAdsVM = MapWithAdsViewModel(networkService: NetworkService())
        let mapWithAdsVC = MapWithAdsVC(viewModel: mapWithAdsVM)
        let mapWithAdsNC = UINavigationController(rootViewController: mapWithAdsVC)
        mapWithAdsNC.title = "Карта"

        let adsListViewModel = AdsListViewModel(networkService: NetworkService())
        let adsListVC = AdsListViewController(viewModel: adsListViewModel)
        adsListViewModel.view = adsListVC
        let adsListNC = UINavigationController(rootViewController: adsListVC)
        adsListVC.title = "Объявления"

        let profileVM = ProfileViewModel(user: nil, networkService: NetworkService())
        let profileVC = ProfileViewController(viewModel: profileVM)
        profileVM.view = profileVC
        profileVC.title = "Профиль"

        

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        tabBar.addViewControllers(viewControllers: mainTapeNC, mapWithAdsNC, adsListNC, profileVC)

        if let items = tabBar.tabBar.items {
            items[0].image = UIImage(systemName: "book.pages")
            items[1].image = UIImage(systemName: "map")
            items[2].image = UIImage(systemName: "square.stack.3d.down.forward.fill")
            items[3].image = UIImage(systemName: "person.fill")
        }
        return tabBar
    }
}
