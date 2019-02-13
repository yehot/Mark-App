//
//  Move.swift
//  SHWMark
//
//  Created by yehot on 2017/11/9.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

/// 移动 矢量
struct MoveVector {
    
    var x: CGFloat = 0
    var y: CGFloat = 0

    init(_ startPoint:CGPoint, endPoint p2: CGPoint) {
        self.x = p2.x - startPoint.x
        self.y = p2.y - startPoint.y
    }
}
