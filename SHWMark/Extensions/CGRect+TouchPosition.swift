//
//  CGRect+TouchPosition.swift
//  SHWMark
//
//  Created by yehot on 2017/12/7.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

extension CGRect {
    func update(with touchPoint: CGPoint, in position: TouchPosition, originRect: CGRect) -> CGRect {
        let touchedX = touchPoint.x
        let touchedY = touchPoint.y
        
        let originX = originRect.x
        let originY = originRect.y
        let originBottom = originRect.bootomY
        let originright = originRect.rightX
        
        var rect = CGRect.init(origin: self.origin, size: self.size)
        
        switch position {
        case .Left:
            rect.width = abs(touchedX - originright)
            rect.x = min(touchedX, originright)
            break
            
        case .Top:
            rect.height = abs(touchedY - originBottom)
            rect.y = min(touchedY, originBottom)
            break
            
        case .Bottom:
            rect.height = abs(touchedY - originY)
            rect.y = min(touchedY, originY)
            break
            
        case .Right:
            rect.width = abs(touchedX - originX)
            rect.x = min(touchedX, originX)
            break
            
        case .LeftTop:
            rect.width = abs(touchedX - originright)
            rect.x = min(touchedX, originright)
            rect.height = abs(touchedY - originBottom)
            rect.y = min(touchedY, originBottom)
            break
            
        case .LeftBottom:
            rect.width = abs(touchedX - originright)
            rect.x = min(touchedX, originright)
            rect.height = abs(touchedY - originY)
            rect.y = min(touchedY, originY)
            break
            
        case .RightTop:
            rect.height = abs(touchedY - originBottom)
            rect.y = min(touchedY, originBottom)
            rect.width = abs(touchedX - originX)
            rect.x = min(touchedX, originX)
            break
            
        case .RightBottom:
            rect.width = abs(touchedX - originX)
            rect.x = min(touchedX, originX)
            rect.height = abs(touchedY - originY)
            rect.y = min(touchedY, originY)
            break
            
        case .Inside:
            break
            
        case .Outside:
            break
        }
        return rect
    }
}

extension CGRect {
    public func move(from startPoint: CGPoint, endPoint p2: CGPoint) -> CGRect {
        let moveX = p2.x - startPoint.x
        let moveY = p2.y - startPoint.y
        return CGRect.init(x: self.x + moveX, y: self.y + moveY, width: self.width, height: self.height)
    }
}

