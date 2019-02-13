//
//  MarkListDataParse.swift
//  SHWMark
//
//  Created by yehot on 2017/11/20.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import APIKit
import SwiftyJSON

// temp 暂时不用
class MarkListDataParse: DataParser {
    var contentType: String?

    // json data to model
    // DataParser 默认是 json data to dict
    func parse(data: Data) throws -> Any {
        let jsonObj = try JSON(data: data)
        return try Model.init(json: jsonObj)
    }
}

// temp
struct Model {
    let name: String
    let description: String
    
    init(json object: JSON) throws {
        // TODO: json 转 model 框架
        self.name = object["name"].stringValue
        self.description = object["description"].stringValue
    }
}
