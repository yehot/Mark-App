//
//  PostMarkTaskResponse.swift
//  SHWMark
//
//  Created by yehot on 2017/11/29.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation

class SubmitTaskResponse {
    var code: Int?      // 目前接口未规范此字段
    var msg: String?
    
    var model: MarkTaskSubmitModel?
}
