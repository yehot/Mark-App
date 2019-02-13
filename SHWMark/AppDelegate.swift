//
//  AppDelegate.swift
//  SHWMark
//
//  Created by yehot on 2017/10/27.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
//import SHWAccountSDK
//import SHWAnalyticsSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let rootNav = MarkNavigationController.init(rootViewController: MarkJobListViewController())
        window?.rootViewController = rootNav

        setupAccountCenter()

        SHWSocialManager.setupSocialPlatform()

        ImageCacheManager.setupKingFisherCacheLimit(50 * 1024 * 1024)   // 50M
        
        return true
    }
}

// MARK: - handle open url
extension AppDelegate {
    // iOS9及以上
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SHWSocialManager.canHandle(open: url, options: options)
    }
    
    // 已废弃方法，用于支持iOS8及以下
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return self.application(application, open: url, options: [UIApplication.OpenURLOptionsKey : Any]())
    }
    
    //  for web share of weibo
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return self.application(application, open: url)
    }
}

// MARK: - config center setup
extension AppDelegate {
    fileprivate func setupConfigCenter() {
        ConfigCenterService.registerSHWConfigCenterService()
        
//        let notifaction = ConfigCenterService.configCenterPullFinishNotification
//        NotificationCenter.default.addObserver(self, selector:#selector(notificationUpdateAppVersion(noti:)), name: notifaction, object:nil)
    }
    
    @objc private func notificationUpdateAppVersion(noti: Notification) {
        ConfigCenterService.handleConfigCenterPullFinishNotification(noti) { (needForceUpdate) in
            
        }
    }
}

// MARK: - Account Center
extension AppDelegate {
    fileprivate func setupAccountCenter() {
//        SHWAccountSDK.setup { (config) in
//            config.appKey = AccountManager.Config.appKey
//            config.appEnv = .debug
//        }
    }
}
