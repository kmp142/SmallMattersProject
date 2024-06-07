//
//  SceneDelegate.swift
//  SmallMattersProject
//
//  Created by Dmitry on 17.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let firebaseAuthManager = AuthManager.shared
        let authVM = AuthViewModel(authManager: firebaseAuthManager)
        let authVC = AuthVC(viewModel: authVM)
        authVM.view = authVC

        let json = """
        {
            "adDescription": "Нужно будет свозить помыть машину на мойку по адресу ул. Измайлова, д. 28. Все каналы связи доступны, звоните или пишите в телеграм",
            "bounty": 1000,
            "deadline": "2024-06-27'12:00:00",
            "distanceToUser": 300,
            "id": "1",
            "locationLatitude": 55.791941,
            "locationLongitude": 49.126231,
            "minimalExecutorRating": 5,
            "title": "Свозить помыть машину",
            "state": "active",
            "authorId": "KbgV6C0z2dS2k9Usir0vWY2iVsZ2",
            "executorId": "",
            "review": {}
          }
        """

        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = PersistentContainer.shared.viewContext
        let encoder = JSONEncoder()
        encoder.userInfo[CodingUserInfoKey.managedObjectContext] = PersistentContainer.shared.viewContext

        let ad = try? decoder.decode(Ad.self, from: json.data(using: .utf8)!)

        let encodedJson = try? encoder.encode(ad)

        if let json = encodedJson {
            print("Энкодированный объект:\(String(data: json, encoding: .utf8) ?? "")")
        }



        let networkService = NetworkService()

        if let ad = ad {
            ad.distanceToUser = 12
            Task{
                try await networkService.updateAd(ad: ad)
            }
        }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = TabBarAssembly().configureTabBar()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

