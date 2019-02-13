//
//  NSString+Width.swift
//  SHWMark
//
//  Created by yehot on 2017/12/7.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func textWidth(with font: UIFont, constrainedToHeight height: Double) -> CGFloat {
        let string = NSString(string: self)
        let esSize = CGSize(width: .greatestFiniteMagnitude, height: height)
        let rect = string.boundingRect(with: esSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return rect.size.width
    }
}
