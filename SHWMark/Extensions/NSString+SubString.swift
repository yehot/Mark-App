//
//  NSString+Extension.swift
//  SHWMark
//
//  Created by yehot on 2017/11/21.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation

extension String {
    func subString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func subString(from index: Int) -> String {
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}
