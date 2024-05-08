import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let appearanceViewModel = AppearanceViewModel
//    let appearanceViewModel = AppearanceViewModel(appearance: AppearanceModel(isDarkModeEnabled: false,
//                                                                             boxCornerRadius: 0,
//                                                                             backgroundColor: .init(red: 255,
//                                                                                                    green: 255,
//                                                                                                    blue: 255)))

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }


        let window = UIWindow(windowScene: windowScene)
        let realmDatabaseManager = RealmDatabaseManager()
        let swiftDataDatabaseManager = SwiftDataDatabaseManager()

        let viewModel = InventoryViewModel(databaseManager: realmDatabaseManager)

        let inventoryListVC = InventoryListViewController(viewModel: viewModel)
        let trashVC = TrashViewController(viewModel: viewModel)
        let settingVC = SettingsViewController()

        let tabBarController = UITabBarController()

        let inventoriesImage = UIImage(systemName: "note.text")
        let trashImage = UIImage(systemName: "trash.circle")
        let settingImage = UIImage(systemName: "gear")


        inventoryListVC.tabBarItem = UITabBarItem(title: "Inventarios", image: inventoriesImage, tag: 0)
        trashVC.tabBarItem = UITabBarItem(title: "Papelera", image: trashImage, tag: 1)
        settingVC.tabBarItem = UITabBarItem(title: "Ajustes", image: settingImage, tag: 2)

        let inventoryListNavigationController = UINavigationController(rootViewController: inventoryListVC)
        let trashNavigationController = UINavigationController(rootViewController: trashVC)
        let settingsNavigationController = UINavigationController(rootViewController: settingVC)

        tabBarController.viewControllers = [inventoryListNavigationController,
                                            trashNavigationController,
                                            settingsNavigationController]

        window.rootViewController = tabBarController

        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    }


}
