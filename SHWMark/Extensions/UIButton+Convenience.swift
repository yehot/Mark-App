//
//  UIButton+Extension.swift
//  SHWMark
//
//  Created by yehot on 2017/11/7.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(title: String, target: Any,action: Selector) {
        self.init()
        self.setTitle(title, for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
    
    convenience init(title: String, textColor: UIColor, backColor: UIColor = .white) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backColor
    }
    
    convenience init(image name: String, target: Any,action: Selector) {
        self.init()
        self.setImage(UIImage.init(named: name), for: .normal)
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
