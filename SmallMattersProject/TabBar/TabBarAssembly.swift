//
//  TabBarAssembly.swift
//  SmallMattersProject
//
//  Created by Dmitry on 25.03.2024.
//

import Foundation
import UIKit

class TabBarAssembly {

    let userRepository = UserRepository<User>(context: PersistentContainer.shared.viewContext)

    func configureTabBar() -> UITabBarController {
        let tabBar = TabBarController()

        let mainTapeVM = MainTapeViewModel()
        let mainTapeVC = MainTapeViewController(viewModel: mainTapeVM)
        let mainTapeNC = UINavigationController(rootViewController: mainTapeVC)
        mainTapeVC.title = "Лента"

        let mapWithAdsVM = MapWithAdsViewModel()
        let mapWithAdsVC = MapWithAdsVC(viewModel: mapWithAdsVM)
        mapWithAdsVC.title = "Карта"

        let adsListVC = AdsListViewController()
        let adsListNC = UINavigationController(rootViewController: adsListVC)
        adsListVC.title = "Объявления"

        let chatsListVC = ChatsListViewController()
        chatsListVC.title = "Сообщения"

        let loggedInUser = userRepository.fetchLoggedInUser() 
        let profileVM = ProfileViewModel(user: loggedInUser)
        let profileVC = ProfileViewController(viewModel: profileVM)
        profileVC.title = "Профиль"

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        tabBar.addViewControllers(viewControllers: mainTapeNC, mapWithAdsVC, adsListNC, chatsListVC, profileVC)

        if let items = tabBar.tabBar.items {
            items[0].image = UIImage(systemName: "book.pages")
            items[1].image = UIImage(systemName: "map")
            items[2].image = UIImage(systemName: "square.stack.3d.down.forward.fill")
            items[3].image = UIImage(systemName: "message.fill")
            items[4].image = UIImage(systemName: "person.fill")
        }
        return tabBar
    }
}
