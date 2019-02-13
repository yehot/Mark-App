//
//  MarkListRequest.swift
//  SHWMark
//
//  Created by yehot on 2017/11/20.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import APIKit

struct MarkListRequest: Request {
    
    // MARK: - parameters
    var page: Int
    var size: Int
//    var stauts: Int = 0
    
    init(page: Int = 1, size: Int = 20) {
        self.page = page
        self.size = size
    }
    
    // MARK: - <Request>
    typealias Response = MarkListModel
    
    var baseURL: URL {
        return URL(string: NetworkConst.kGlobalBaseURL)!
    }
    
    var path: String {
        return "/projects"
    }
    
    var parameters: Any? {
        return [
            "page" : "\(page)",
            "size" : "\(size)"
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
//    var dataParser: DataParser {
//        return MarkListDataParse()
//    }
    
    // 如果没有重载 dataParser，返回的 object 默认是 dict
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> MarkListModel {
        // object 由 dataParser 的 parse() 解析得出
//        guard let model = object as? MarkListModel else {
//            throw ResponseError.unexpectedObject(object)
//        }
        guard let dict = object as? [String:Any] else {
            throw ResponseError.unexpectedObject(object)
        }
        return MarkListModel.init(fromDictionary: dict)
    }
}
