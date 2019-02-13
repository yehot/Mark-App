//
//  NSString+Validate.swift
//  SHWMark
//
//  Created by yehot on 2017/12/27.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation

extension String {
    func validateMobile() -> Bool {
        // "^1[0-9]{10}$"
        let phoneRegex: String = "^((13[0-9])|(15[0-9])|(18[0-9])|(17[0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
}
