//
//  TouchPosition.swift
//  SHWMark
//
//  Created by yehot on 2017/11/3.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

/// UITouch 相对于矩形框的 Position
enum TouchPosition {
    // 边框线
    case Left
    case Right
    case Top
    case Bottom
    
    /// 边框内
    case Inside
    /// 边框外
    case Outside
    
    // 边框顶点
    case LeftTop
    case LeftBottom
    case RightTop
    case RightBottom
    
    init(ofPoint point: CGPoint, inRect rect: CGRect) {
        
        // FIXME: 作用区域太大会有问题
        let effectiveRegion: CGFloat = 10.0
        
        let touchedX = point.x
        let touchedY = point.y
        
        let leftX = rect.x
        let leftY = rect.y
        let width = rect.width
        let height = rect.height
        
        if (touchedX > leftX - effectiveRegion && touchedX < leftX + effectiveRegion
            && touchedY > leftY - effectiveRegion && touchedY < leftY + effectiveRegion) { //左上角区域
            self = .LeftTop
        } else if (touchedX > leftX + width - effectiveRegion && touchedX < leftX + width +
            effectiveRegion
            && touchedY > leftY - effectiveRegion && touchedY < leftY + effectiveRegion) { //右上角区域
            self = .RightTop
        } else if (touchedX > leftX - effectiveRegion && touchedX < leftX + effectiveRegion
            && touchedY > leftY + height - effectiveRegion && touchedY < leftY + height +
            effectiveRegion) { //左下角区域
            self = .LeftBottom
            
        } else if (touchedX > leftX + width - effectiveRegion && touchedX < leftX + width +
            effectiveRegion
            && touchedY > leftY + height - effectiveRegion && touchedX < leftX + width +
            effectiveRegion) { //右下角区域
            self = .RightBottom
        } else if (touchedX > leftX - effectiveRegion && touchedX < leftX + effectiveRegion
            && touchedY > leftY + effectiveRegion && touchedY < leftY + height +
            effectiveRegion) { //左侧
            self = .Left
        } else if (touchedX > leftX + effectiveRegion && touchedX < leftX + width - effectiveRegion
            && touchedY > leftY - effectiveRegion && touchedY < leftY + effectiveRegion) { //上方
            self = .Top
        } else if (touchedX > leftX + width - effectiveRegion && touchedX < leftX + width +
            effectiveRegion
            && touchedY > leftY + effectiveRegion && touchedY < leftY + width -
            effectiveRegion) { //右侧
            self = .Right
        } else if (touchedX > leftX + effectiveRegion && touchedX < leftX + width + effectiveRegion
            && touchedY > leftY + height - effectiveRegion && touchedY < leftY + height +
            effectiveRegion) { //下方
            self = .Bottom
        } else if (touchedX > leftX + effectiveRegion && touchedX < leftX + width - effectiveRegion
            && touchedY > leftY + effectiveRegion && touchedY < leftY + height -
            effectiveRegion) { //中间区域
            self = .Inside
        } else {
            self = .Outside
        }
    }
}
