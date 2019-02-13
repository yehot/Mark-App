//
//  CGRect+Extension.swift
//  SHWMark
//
//  Created by yehot on 2017/11/6.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

extension CGRect {
    public var x: CGFloat {
        get {
            return self.origin.x
        }
        set {
            self.origin.x = newValue
        }
    }
    public var y: CGFloat {
        get {
            return self.origin.y
        }
        set {
            self.origin.y = newValue
        }
    }
    public var width: CGFloat {
        get {
            return self.size.width
        }
        set {
            self.size.width = newValue
        }
        
    }
    public var height: CGFloat {
        get {
            return self.size.height
        }
        set {
            self.size.height = newValue
        }
    }
    /// 底部边框的 y 值
    public var bootomY: CGFloat {
        return self.y + height
    }
    /// 右侧边框的 x 值
    public var rightX: CGFloat {
        return self.x + width
    }
}

extension CGRect {
    init(left: Float, right: Float, top: Float, bottom: Float) {
        self.init(x: CGFloat(left), y: CGFloat(top), width: CGFloat(right - left), height: CGFloat(top - bottom))
    }
}

extension CGRect {
    init(startPoint p1: CGPoint, endPoint p2: CGPoint) {
        var leftTopX = p1.x
        var leftTopY = p1.y    //4 quadrant
        if (p2.x > p1.x && p2.y < p1.y) {    //1
            leftTopY = p2.y
        } else if (p2.x < p1.x && p2.y < p1.y) {    //2
            leftTopX = p2.x
            leftTopY = p2.y
        } else if (p2.x < p1.x && p2.y > p1.y) {    //3
            leftTopX = p2.x
        }
        let _width = abs(p1.x - p2.x)
        let _height = abs(p1.y - p2.y)
        self.init(x: leftTopX, y: leftTopY, width: _width, height: _height)
    }
}
