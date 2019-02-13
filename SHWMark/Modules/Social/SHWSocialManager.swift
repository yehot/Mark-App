//
//  SocialManager.swift
//  SHWMark
//
//  Created by yehot on 2017/12/7.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import UIKit

struct SocialConfig {
    struct Weibo {
        static let appSecret = ""
        static let appKey = ""
        static let redirectURL = ""
        
        static let schema = ""
    }
    
    struct Wechat {
        static let appSecret = ""
        static let appKey = ""
    }
    struct Moments {
        static let appSecret = ""
        static let appKey = ""
    }
    
    struct QQ {
        static let appKey = ""
        
        static let schema = ""
    }
    
    struct UMeng {
        static let appKey = ""
    }
}

class SHWSocialManager {
    static func setupSocialPlatform() {

//        UMSocialManager.default().openLog(false)
//
//        // 友盟
//        UMSocialManager.default().umSocialAppkey = SocialConfig.UMeng.appKey
//        // 微信
//        UMSocialManager.default().setPlaform(.wechatSession,
//                                             appKey: SocialConfig.Wechat.appKey,
//                                             appSecret: SocialConfig.Wechat.appSecret,
//                                             redirectURL: nil)
//        UMSocialManager.default().setPlaform(.wechatTimeLine,
//                                             appKey: SocialConfig.Moments.appKey,
//                                             appSecret: SocialConfig.Moments.appSecret,
//                                             redirectURL: nil)
//        // QQ
//        UMSocialManager.default().setPlaform(.QQ,
//                                             appKey: SocialConfig.QQ.appKey,
//                                             appSecret: nil,
//                                             redirectURL: nil)
//        // 微博
//        UMSocialManager.default().setPlaform(.sina,
//                                             appKey: SocialConfig.Weibo.appKey,
//                                             appSecret: SocialConfig.Weibo.appSecret,
//                                             redirectURL: nil)
    }
    
    static func canHandle(open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        guard let schema = url.scheme else {
            return true
        }
        print("url.schema: \(schema)")
        
        var handleByUmeng = false

        switch schema {
        case SocialConfig.QQ.schema:
            print("QQ回调")
            handleByUmeng = true
            //return TencentOAuth.handleOpen(url)
            
        case SocialConfig.Wechat.appKey:
            print("微信回调")
            handleByUmeng = true
            //return WXApi.handleOpen(url, delegate: self)

        case SocialConfig.Weibo.schema:
            print("微博回调")
            handleByUmeng = true

        default:
            print("----")
        }
        
        if handleByUmeng == true {
//            return UMSocialManager.default().handleOpen(url, options:options)
            return true
        }
        return true
    }
}
