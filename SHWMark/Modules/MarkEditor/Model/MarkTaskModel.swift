//
//  MarkTaskModel.swift
//  SHWMark
//
//  Created by yehot on 2017/11/27.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation
import SwiftyJSON

/// response json model of GetMarkTaskRequest
struct MarkTaskModel {

    var action : String!            // 任务类型： 标注任务 / check 任务
    var checkTimes : String!
    var creatorName : String!

    var data : String!              // json string
    var dataObj: DataObj  {
        let jsonObj = JSON(parseJSON: data)
        let dict = jsonObj.dictionaryObject
        return DataObj(fromDictionary: dict!)
    }
    
    var gmtCreate : String!
    var gmtModified : String!
    var id : Int!                   // task id
    var key : String!
    var labelTimes : String!
    var modifierName : String!
    var projectId : Int!
    
    var moMore: Bool = false
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        action = dictionary["action"] as? String
        checkTimes = dictionary["checkTimes"] as? String
        creatorName = dictionary["creatorName"] as? String
        data = dictionary["data"] as? String
        gmtCreate = dictionary["gmtCreate"] as? String
        gmtModified = dictionary["gmtModified"] as? String
        id = dictionary["id"] as? Int
        key = dictionary["key"] as? String
        labelTimes = dictionary["labelTimes"] as? String
        modifierName = dictionary["modifierName"] as? String
        projectId = dictionary["projectId"] as? Int
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
        if checkTimes != nil{
            dictionary["checkTimes"] = checkTimes
        }
        if creatorName != nil{
            dictionary["creatorName"] = creatorName
        }
        if data != nil{
            dictionary["data"] = data
        }
        if gmtCreate != nil{
            dictionary["gmtCreate"] = gmtCreate
        }
        if gmtModified != nil{
            dictionary["gmtModified"] = gmtModified
        }
        if id != nil{
            dictionary["id"] = id
        }
        if key != nil{
            dictionary["key"] = key
        }
        if labelTimes != nil{
            dictionary["labelTimes"] = labelTimes
        }
        if modifierName != nil{
            dictionary["modifierName"] = modifierName
        }
        if projectId != nil{
            dictionary["projectId"] = projectId
        }
        return dictionary
    }
    
}

struct DataObj {
    
    var imageUrl : String!
    var markInfo : [AnyObject]!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        imageUrl = dictionary["imageUrl"] as? String
        markInfo = dictionary["markInfo"] as? [AnyObject]
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if imageUrl != nil{
            dictionary["imageUrl"] = imageUrl
        }
        if markInfo != nil{
            dictionary["markInfo"] = markInfo
        }
        return dictionary
    }
}
