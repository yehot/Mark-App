//
//  LoginViewModel.swift
//  SHWMark
//
//  Created by yehot on 2017/11/20.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {

    let validatedPhone: Observable<Bool>
    let validatedSmsCode: Observable<Bool>

    let loginBtnEnabled: Observable<Bool>
    
    init(input:(
        phone: Observable<String>,
        smsCode: Observable<String>,
        loginTap: Observable<Void>
        )) {
        
        validatedPhone = input.phone.map({ (phone) -> Bool in
//            if phone.length != 11 {
//                return false
//            }
            return phone.validateMobile()
        }).share(replay: 1)

        validatedSmsCode = input.smsCode.map({ (code) -> Bool in
//            return code.length == 6 ? true : false
            return true
        }).share(replay: 1)
        
        // distinctUntilChanged 阻止 Observable 发出相同的元素。如果后一个元素和前一个元素是相同的，那么这个元素将不会被发出来
        // share(replay: 使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。即使这些元素是在订阅前产生的
        loginBtnEnabled = Observable.combineLatest(validatedPhone, validatedSmsCode, resultSelector: { (phone, smsCode) -> Bool in
            return phone && smsCode
        })
            .distinctUntilChanged()
            .share(replay: 1)
    }
}
