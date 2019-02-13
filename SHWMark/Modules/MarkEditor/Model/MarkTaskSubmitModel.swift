//
//  MarkTaskSubmitModel.swift
//  SHWMark
//
//  Created by yehot on 2017/11/29.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

/// response json model of SubmitTaskRequest
struct MarkTaskSubmitModel {
    
    var action : String!
    var creator : Int!
    var gmtCreate : String!
    var id : Int!
    var taskId : Int!
    var taskResultJson : String!
    
//    var taskResultJsonObj : [TaskResultJson] {
//        let json = JSON(taskResultJson)
//        let array = json.
//        // TODO:  json 对象的 string，转 model string
//        
//    }

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        action = dictionary["action"] as? String
        creator = dictionary["creator"] as? Int
        gmtCreate = dictionary["gmtCreate"] as? String
        id = dictionary["id"] as? Int
        taskId = dictionary["taskId"] as? Int
        taskResultJson = dictionary["taskResultJson"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if action != nil{
            dictionary["action"] = action
        }
        if creator != nil{
            dictionary["creator"] = creator
        }
        if gmtCreate != nil{
            dictionary["gmtCreate"] = gmtCreate
        }
        if id != nil{
            dictionary["id"] = id
        }
        if taskId != nil{
            dictionary["taskId"] = taskId
        }
        if taskResultJson != nil{
            dictionary["taskResultJson"] = taskResultJson
        }
        return dictionary
    }
}

struct TaskResultJson {
    
    var left : Float!
    var right : Float!
    var top : Float!
    var bottom : Float!

    var type : String!      // 用于表示方框、圆
    var key : String!       // 用于标记表示的是 人脸、汽车
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bottom = dictionary["bottom"] as? Float
        key = dictionary["key"] as? String
        left = dictionary["left"] as? Float
        right = dictionary["right"] as? Float
        top = dictionary["top"] as? Float
        type = dictionary["type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bottom != nil{
            dictionary["bottom"] = bottom
        }
        if key != nil{
            dictionary["key"] = key
        }
        if left != nil{
            dictionary["left"] = left
        }
        if right != nil{
            dictionary["right"] = right
        }
        if top != nil{
            dictionary["top"] = top
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}

extension TaskResultJson {
    var frame: CGRect {
        return CGRect.init(left: left, right: right, top: top, bottom: bottom)
    }
    
    init(result: MarkResult) {
        let rect = result.rect
        self.key = result.type.shape
        self.type = result.type.task
        left = Float(rect.x)
        right = Float(rect.rightX)
        bottom = Float(rect.bootomY)
        top = Float(rect.y)
    }
    
    func toJsonString() -> String? {
        let dict = self.toDictionary()
        let jsonObj = JSON(dict)
        guard let str = jsonObj.rawString() else {
            return nil
        }
        return str
    }
}
