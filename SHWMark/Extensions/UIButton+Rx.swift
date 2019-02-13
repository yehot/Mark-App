//
//  UIButton+Rx.swift
//  SHWMark
//
//  Created by yehot on 2017/12/27.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    var tapEnabled: Binder<Bool> {
        return Binder(self.base, binding: { (button, canTap) in
            button.isEnabled = canTap
            // TODO: alpha 的变化，这种写法不通用
            button.alpha = canTap ? 1.0 : 0.5
        })
    }
}
