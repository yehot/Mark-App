//
//  MarkEditAble.swift
//  SHWMark
//
//  Created by yehot on 2017/11/8.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

protocol MarkEditAble {
    
    func undo()
    func redo()
    func removeAll()
    // NOTE: 画的矩形框取 layer 的 bounds，并不是最终的标注结果
    //  需要乘以 ScrollView 的缩放系数
    func getAllMarkInfo() -> [MarkResult]
}
