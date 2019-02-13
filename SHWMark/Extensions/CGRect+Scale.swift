//
//  CGRect+Scale.swift
//  SHWMark
//
//  Created by yehot on 2017/12/7.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

extension CGRect {
    func zoomScale(_ scale: CGFloat) -> CGRect {
        var rect = self
        rect.x *= scale
        rect.y *= scale
        rect.width *= scale
        rect.height *= scale
        return rect
    }
}
