//
//  SceneDelegate.swift
//  GasmanProvider
//
//  Created by Haneen on 08/03/2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    static private(set) var current: SceneDelegate?
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        SceneDelegate.current = self
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        
        let vc = SplashVC(nibName: "SplashVC", bundle: nil)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}
