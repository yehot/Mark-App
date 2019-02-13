//
//  CGPoint+Extension.swift
//  SHWMark
//
//  Created by yehot on 2017/11/3.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(toPoint p: CGPoint) -> CGFloat {
        return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
}
