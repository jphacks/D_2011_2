//
//  AppDelegate.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/10/31.
//

import UIKit
import MobileRTC
import MobileCoreServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MobileRTCAuthDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        authZoomSDK()
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
    
    func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        print(returnValue)
        if returnValue != MobileRTCAuthError_Success {
            print("SDK authentication failed, error code: \(returnValue)")
        } else {
            print("SDK auth suceeded")
        }
    }

    func authZoomSDK() {
        let mainSDK = MobileRTCSDKInitContext.init()
        mainSDK.domain = "zoom.us"
        mainSDK.enableLog = true
        MobileRTC.shared().initialize(mainSDK)
        let authService = MobileRTC.shared().getAuthService()
        if let authService = authService {
            authService.delegate = self
            authService.clientKey = KeyManager().getValue(key: "clientKey")
            authService.clientSecret = KeyManager().getValue(key: "clientSecret")
            authService.sdkAuth()
        }
    }
}

