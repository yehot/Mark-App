//
//  MarkResult.swift
//  SHWMark
//
//  Created by yehot on 2017/11/30.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SwiftyJSON

struct MarkLayerType {
    /// 标记种类（人、车），对应 json 的 key
    let task: String
    /// 标注形状（方、圆），对应 json 的 type:
    let shape: String
}

/// 标注结果
struct MarkResult {
    // NOTE: 标注结果最终提交时的数据结构为 TaskResultJson 转出的 json string
    let rect: CGRect
    let type: MarkLayerType
}

extension MarkResult {
    
    static func jsonStringWithMarkResultArray(_ resultArray: [MarkResult]) -> String? {
        var strArray = [String]()
        for mResult in resultArray {
            if let jsonStr = mResult.toJsonString() {
                strArray.append(jsonStr)
            }
        }
        let json = JSON(strArray)
        let jsonString = json.rawString()
        return jsonString
    }
    
    private func toJsonString() -> String? {
        // NOTE: 取的上下左右，而非x、y、宽高
        let taskObj = TaskResultJson.init(result: self)
        guard let jsonStr = taskObj.toJsonString() else {
            return nil
        }
        return jsonStr
    }
}
