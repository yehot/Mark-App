//
//  MarkShapeLayer.swift
//  SHWMark
//
//  Created by yehot on 2017/12/14.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

protocol MarkUndoAble: NSCopying {
    
}

// TODO: RectangleLayer 之上，可以抽象一层父类 MarkShapeLayer
// 需要包含通用的  type（mark Type）： 方还是圆  key(action Type)： 人脸，还是车
class MarkShapeLayer: CAShapeLayer, MarkUndoAble {

    func copy(with zone: NSZone? = nil) -> Any {
        fatalError("MarkShapeLayer can not use directly，use sub class")
    }
}
