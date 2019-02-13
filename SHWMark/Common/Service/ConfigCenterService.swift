//
//  ConfigCenterService.swift
//  SHWMark
//
//  Created by Yang Yang on 2017/11/9.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
//import SHWConfigCenter

struct UpdateApp {
    static let kIgnoredVersionKeyUD: String = "SHW_IgnoredVersionKeyUD"
    static let KForUpdateAppDict: String = "updateApp"    // TODO:
    static let kLatestVersion: String = "version"
    static let kNeedForceUpdate: String = "forceUpdate"
}

class ConfigCenterService {
    
    // TODO: 测试地址
    private static let configCenterDomain = "sigma/ios"
    
    // MARK: - init

    /// 注册 ConfigCenterService
    static func registerSHWConfigCenterService() {
//        SHWConfigCenter.register(withAppVersion: currentVersion) { (settings) in
//            settings.domain = configCenterDomain
//        }
    }
    
    // MARK: - public （optional）
    
    /// 配置中心拉取完成的通知
    /// - usage: 注册此通知，回调的 noti.object 为拉取的最新配置 dict
//    static var configCenterPullFinishNotification: Notification.Name {
//        return Notification.Name(configCenterNotificationName)
//    }
    
    /// 处理配置中心下载完成的通知 中，关于 app 升级的 info
    /// - 由于配置中心拉取到最新配置后，无法直接更新内存中的旧配置，目前只能通过通知发出来使用
    static func handleConfigCenterPullFinishNotification(_ noti: Notification, completionWith resultOfNeedUpdateInfo: ((_ needForceUpdate: Bool) -> ())) {
        
        guard let dic = noti.object as? [String: Any] else {
            return
        }
        if self.appNeedUpdate(with: dic) {
            guard let forcedUpdate = dic[UpdateApp.kNeedForceUpdate] as? Bool else {
                resultOfNeedUpdateInfo(false)
                return
            }
            resultOfNeedUpdateInfo(forcedUpdate)
        }
    }
    
    // MARK: - private
    private static let currentVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
//    private static var configCenterNotificationName: String {
//        return SHWConfigCenter.notificationName(forDomain: ConfigCenterService.configCenterDomain)
//    }

    /// check need update
    private static func appNeedUpdate(with configDict: [String: Any]) -> Bool {

        guard let latestVersion = configDict[UpdateApp.kLatestVersion] as? String else {
            return false
        }
        //判断版本号
        if  latestVersion.compare(ConfigCenterService.currentVersion, options:.numeric) == .orderedDescending {
            return true
        }
        return false
    }
}
