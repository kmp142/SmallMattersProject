//
//  TabBarAssembly.swift
//  SmallMattersProject
//
//  Created by Dmitry on 25.03.2024.
//

import Foundation
import UIKit

class TabBarAssembly {

    func configureTabBar() -> UITabBarController {
        let tabBar = TabBarController()

        let mainTapeVM = MainTapeViewModel()
        let mainTapeVC = MainTapeViewController(viewModel: mainTapeVM)
        mainTapeVC.title = "Лента"

        let mapWithAdsVM = MapWithAdsViewModel()
        let mapWithAdsVC = MapWithAdsVC(viewModel: mapWithAdsVM)
        mapWithAdsVC.title = "Карта"

        let storageVC = AdsStorageViewController()
        storageVC.title = "Объявления"

        let chatsListVC = ChatsListViewController()
        chatsListVC.title = "Сообщения"

        let profileVC = ProfileViewController()
        profileVC.title = "Профиль"

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        tabBar.addViewControllers(viewControllers: mainTapeVC, mapWithAdsVC, storageVC, chatsListVC, profileVC)

        guard let items = tabBar.tabBar.items else { return tabBar}

        items[0].image = UIImage(systemName: "book.pages")
        items[1].image = UIImage(systemName: "map")
        items[2].image = UIImage(systemName: "square.stack.3d.down.forward.fill")
        items[3].image = UIImage(systemName: "message.fill")
        items[4].image = UIImage(systemName: "person.fill")

        return tabBar
    }
}
