import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let timeManager = TimeManagerImpl()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let uiscene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = TimerViewControllerOnViewModel(viewModel: timeManager)
//        window.rootViewController = TimerViewControllerOnViewState(timeManager: timeManager)
        window.makeKeyAndVisible()
        window.windowScene = uiscene
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

// Used only for TimerViewControllerOnViewModel
extension TimeManagerImpl: TimerViewModel { }
