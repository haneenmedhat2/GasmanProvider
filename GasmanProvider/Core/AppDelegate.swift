//
//  AppDelegate.swift
//  GasmanProvider
//
//  Created by Haneen on 08/03/2026.
//

import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import IQKeyboardManagerSwift
import IQKeyboardToolbarManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Properties -
    
    let gcmMessageIDKey = "gcm.message_id"
    let googleMapKey = UserDefaults.googleMapKey
    
    //MARK: - Initializer -
    
    override init() {
        super.init()
        UIFont.overrideInitialize()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        self.handleKeyboard()

        self.handleGoogleMap()
        
        self.handleFCMFor(application)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    

    
    //MARK: - Google Maps -
    
    private func handleGoogleMap() {
        GMSServices.provideAPIKey("AIzaSyARVFoBCNcEjpdpQ8B7awHlo2wSAAR63wc")
    }
    
    //MARK: - Keyboard -
    
    private func handleKeyboard() {
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.isEnabled = true
        IQKeyboardToolbarManager.shared.toolbarConfiguration.tintColor = UIColor(resource: .main)
        //KeyboardStateManager.shared.start()
    }
    
//    //MARK: - FCM -
    private func handleFCMFor(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }
}

