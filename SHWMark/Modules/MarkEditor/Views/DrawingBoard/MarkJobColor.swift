//
//  MarkJobType.swift
//  SHWMark
//
//  Created by yehot on 2017/12/6.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

/// 标注任务的配色
enum MarkJobColor {
    // NOTE: 标注的类型可以有无限种，但是每个标注任务最多包含 5 种类型
    case clolor0
    case clolor1
    case clolor2
    case clolor3
    case clolor4
    
    init(num: Int) {
        switch num {
        case 1:
            self = .clolor1
        case 2:
            self = .clolor2
        case 3:
            self = .clolor3
        case 4:
            self = .clolor4
        default:
            self = .clolor0
        }
    }
}

// 以下是这 5 种类型的颜色：
extension MarkJobColor: RawRepresentable {

    typealias RawValue = UIColor

    init?(rawValue: UIColor) {
        fatalError("init(rawValue:) has not been implemented")
    }
    
    var rawValue: UIColor {
        switch self {
        case .clolor0:
            return UIColor("#e91e63")!
        case .clolor1:
            return UIColor("#2196f3")!
        case .clolor2:
            return UIColor("#ffeb3b")!
        case .clolor3:
            return UIColor("#ff9800")!
        case .clolor4:
            return UIColor("#3f5ab5")!
        }
    }
}
