//
//  UIEvent+Extension.swift
//  SHWMark
//
//  Created by yehot on 2017/11/3.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

extension UIEvent {
    public var isMultipleTouch: Bool {
        guard let count = self.allTouches?.count else {
            return false
        }
        if count > 1 {
            return true
        }
        return false
    }
}
