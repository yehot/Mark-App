//
//  AccountManager.swift
//  SHWMark
//
//  Created by yehot on 2017/11/29.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
//import SHWAccountSDK

// const
extension AccountManager {
    /// 存在 NSUserDefault 中的 keys
    struct UserDefaultKeys {
        static let shw_isLoggedIn = "shw_mark_isLoggedIn"
        static let shw_userID = "shw_mark_user_id"
        static let shw_phone = "shw_mark_phone_number"
        static let shw_token = "shw_mark_token"
    }
    struct Config {
        /// appkey of SHWAccountCenter
        static let appKey = ""
    }
}

extension AccountManager {
    var tocken: String? {
        return UserDefaults.standard.string(forKey: UserDefaultKeys.shw_token)
    }
    
    var hasTocken: Bool {
        guard let t = tocken else {
            return false
        }
        if t.isEmpty {
            return false
        }
        return true
    }
}

class AccountManager {
    
    static let shared = AccountManager()
    private init() {}
    
    // TODO: currentUser 应该为 optional 类型
    private(set) lazy var currentUser: User = {
        if self.isLoggedIn() {
            var user = User()
            user.userID = UserDefaults.standard.string(forKey: UserDefaultKeys.shw_isLoggedIn)
            user.phoneNum = UserDefaults.standard.string(forKey: UserDefaultKeys.shw_phone)
            return user
        }
        return User()
    }()
    
    func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultKeys.shw_isLoggedIn)
    }
    
    /// 登录成功时调用，需要同时调用 recordUserID()
    func loginSuccess() {
        UserDefaults.standard.set(true, forKey: UserDefaultKeys.shw_isLoggedIn)
    }
    func recordUserID(_ userID: String, phone: String, token: String) {
        // NOTE: 记录的状态在登出时，必须全部清除
        UserDefaults.standard.set(userID, forKey: UserDefaultKeys.shw_userID)
        currentUser.userID = userID
        
        UserDefaults.standard.set(phone, forKey: UserDefaultKeys.shw_phone)
        currentUser.phoneNum = phone
        
        UserDefaults.standard.set(phone, forKey: UserDefaultKeys.shw_token)
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.shw_isLoggedIn)

        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.shw_userID)
        currentUser.userID = nil

        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.shw_phone)
        currentUser.phoneNum = nil

        UserDefaults.standard.removeObject(forKey: UserDefaultKeys.shw_token)
    }
}
