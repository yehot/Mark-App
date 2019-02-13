//
//  PostMarkTaskRequest.swift
//  SHWMark
//
//  Created by yehot on 2017/11/29.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import APIKit

// 提交标注结果
class SubmitTaskRequest: Request {
    
    // MARK: - parameters
    private var taskResultJson: String
    private var token: String
    private var action: String
    
    private var taskID: Int
    
    private var cookie: String {
        return "_sw_token" + "=" + token
    }
    
    init(taskID: Int, resultJson: String, action: String, token: String) {
        self.taskID = taskID
        self.taskResultJson = resultJson
        self.token = token
        self.action = action
    }
    
    // MARK: - <Request>
    typealias Response = SubmitTaskResponse
    
    var baseURL: URL {
        return URL(string: NetworkConst.kGlobalBaseURL)!
    }
    
    var path: String {
        return "/task/\(taskID)/result"
    }
    
    var parameters: Any? {
        return [
            "action" : self.action,
            "taskResultJson" : self.taskResultJson
        ]
    }
    
    var headerFields: [String : String] {
        return [
            "Cookie" : cookie
        ]
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    // 如果没有重载 dataParser，返回的 object 默认是 dict
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> SubmitTaskResponse {
        guard let dict = object as? [String:Any] else {
            throw ResponseError.unexpectedObject(object)
        }
        let response = SubmitTaskResponse()
        let model = MarkTaskSubmitModel.init(fromDictionary: dict)
        response.model = model
        return response
    }
}
