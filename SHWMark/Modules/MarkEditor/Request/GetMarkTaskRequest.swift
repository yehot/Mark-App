//
//  GetMarkTaskRequest.swift
//  SHWMark
//
//  Created by yehot on 2017/11/27.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import APIKit

// 获取标注任务
//（任务由后台分发，有可能已经没有了，返回 404……）
class GetMarkTaskRequest: Request {
    
    // MARK: - parameters
    private var projectID: Int
    private var token: String
    
    private var cookie: String {
        return "_sw_token" + "=" + token
    }
    
    init(projectID: Int, token: String) {
        self.projectID = projectID
        self.token = token
    }
    
    // MARK: - <Request>
    typealias Response = GetMarkTaskResponse
    
    var baseURL: URL {
        return URL(string: NetworkConst.kGlobalBaseURL)!
    }
    
    var path: String {
        return "/project/\(projectID)/task"
    }
    
    var headerFields: [String : String] {
        return [
            "Cookie" : cookie
        ]
    }
    
    var method: HTTPMethod {
        return .get
    }
    // 如果没有重载 dataParser，返回的 object 默认是 dict
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> GetMarkTaskResponse {
        guard let dict = object as? [String:Any] else {
            throw ResponseError.unexpectedObject(object)
        }
        let response = GetMarkTaskResponse()
        if let msg = dict["errorMsg"] as? String {
            response.msg = msg
            response.code = 404
            return response
        }
        let model = MarkTaskModel.init(fromDictionary: dict)
        response.model = model
        return response
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard (200..<300).contains(urlResponse.statusCode) else {
            if urlResponse.statusCode == 404 {  // 404 没有更多的图片了
                return object
                // 目前接口设计有问题
                // throw MarkTaskError.nonMoreImage
            }
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
        return object
    }
}

//enum MarkTaskError: Error {
//    case nonMoreImage
//}

