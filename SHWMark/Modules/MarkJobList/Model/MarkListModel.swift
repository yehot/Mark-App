//
//  MarkListModel.swift
//  SHWMark
//
//  Created by yehot on 2017/11/20.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//
// NOTE: 以下代码由 JSON Export 生成。代码格式、换行尽量不要修改，便于接口数据结构变化时，方便对比

import UIKit
import SwiftyJSON

/// response json model of MarkListRequest
struct MarkListModel {
    
    var pageList : [PageListItem]!
    var pageNo : Int!
    var pageSize : Int!
    var totalCount : Int!
    var totalPages : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        pageList = [PageListItem]()
        if let pageListArray = dictionary["pageList"] as? [[String:Any]]{
            for dic in pageListArray{
                let value = PageListItem(fromDictionary: dic)
                pageList.append(value)
            }
        }
        pageNo = dictionary["pageNo"] as? Int
        pageSize = dictionary["pageSize"] as? Int
        totalCount = dictionary["totalCount"] as? Int
        totalPages = dictionary["totalPages"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if pageList != nil{
            var dictionaryElements = [[String:Any]]()
            for pageListElement in pageList {
                dictionaryElements.append(pageListElement.toDictionary())
            }
            dictionary["pageList"] = dictionaryElements
        }
        if pageNo != nil{
            dictionary["pageNo"] = pageNo
        }
        if pageSize != nil{
            dictionary["pageSize"] = pageSize
        }
        if totalCount != nil{
            dictionary["totalCount"] = totalCount
        }
        if totalPages != nil{
            dictionary["totalPages"] = totalPages
        }
        return dictionary
    }
}

// NOTE: 这里不能用 struct
class PageListItem {
    
    // MARK: - FoldingCell binding
    // TODO: 在拿到数据后，需要动态修改 展开的高度
    var openHeight = MarkJobCell.kOpenStateCellHeight    // 默认值
    var isOpening: Bool = false     // 展开状态
    
    // MARK: - 服务端原始数据结构
    var access : String!            //权限控制：PUBLIC,GROUP,PRIVATE
    var creatorName : String!       //创建人
    var descriptionField : String!  //项目描述
    
    var endTime : String!
    var endTimeYYMMDD: String {
        return endTime.subString(to: 10)
    }
    var gmtCreate : String!         //创建时间
    var gmtModified : String!       //最后修改时间
    
    var id : Int!                   //project id
    var joinPersonCount : Int!      //参与人数

    var media : String!             //标注的媒体类型,可取值：IMAGE，TEXT,VOICE,VIDEO
    var medias : [String]!          //示例媒体url列表
    var modifierName : String!      //最后修改人
    
    var name : String!              //项目名称，必须是全局唯一的，不能重复
    var price : Int!                //标注单价，以分为单位，10表示0.1元

    var schema : String!            //包含的标注类型(下发的字段是 json string)
    var schemaObj: Schema {
        let jsonObj = JSON(parseJSON: schema)
        let dict = jsonObj.dictionaryObject
        return Schema(fromDictionary: dict!)
    }
    
    var startTime : String!         //项目开始时间
    var startTimeYYMMDD: String {
        return startTime.subString(to: 10)
    }
    
    var status : Int!               //项目状态，0 未开始，1 已开始，2 已开始且任务都已完成，3 已结束
    var submitCount : Int!          //需要确认的次数
    var submitPrice : Int!          //确认的单价，以分为单位
    
    var taskCount : Int!            //任务总数
    var taskCompletedCount : Int!   //完成任务数
    
    var remainCount: Int {          //剩余任务数(服务端没给)
        return taskCount - taskCompletedCount
    }

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        access = dictionary["access"] as? String
        creatorName = dictionary["creatorName"] as? String
        descriptionField = dictionary["description"] as? String
        endTime = dictionary["endTime"] as? String
        gmtCreate = dictionary["gmtCreate"] as? String
        gmtModified = dictionary["gmtModified"] as? String
        id = dictionary["id"] as? Int
        joinPersonCount = dictionary["joinPersonCount"] as? Int
        media = dictionary["media"] as? String
        medias = dictionary["medias"] as? [String]
        modifierName = dictionary["modifierName"] as? String
        name = dictionary["name"] as? String
        price = dictionary["price"] as? Int
        schema = dictionary["schema"] as? String
        startTime = dictionary["startTime"] as? String
        status = dictionary["status"] as? Int
        submitCount = dictionary["submitCount"] as? Int
        submitPrice = dictionary["submitPrice"] as? Int
        taskCompletedCount = dictionary["taskCompletedCount"] as? Int
        taskCount = dictionary["taskCount"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if access != nil{
            dictionary["access"] = access
        }
        if creatorName != nil{
            dictionary["creatorName"] = creatorName
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if endTime != nil{
            dictionary["endTime"] = endTime
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
        if joinPersonCount != nil{
            dictionary["joinPersonCount"] = joinPersonCount
        }
        if media != nil{
            dictionary["media"] = media
        }
        if medias != nil{
            dictionary["medias"] = medias
        }
        if modifierName != nil{
            dictionary["modifierName"] = modifierName
        }
        if name != nil{
            dictionary["name"] = name
        }
        if price != nil{
            dictionary["price"] = price
        }
        if schema != nil{
            dictionary["schema"] = schema
        }
        if startTime != nil{
            dictionary["startTime"] = startTime
        }
        if status != nil{
            dictionary["status"] = status
        }
        if submitCount != nil{
            dictionary["submitCount"] = submitCount
        }
        if submitPrice != nil{
            dictionary["submitPrice"] = submitPrice
        }
        if taskCompletedCount != nil{
            dictionary["taskCompletedCount"] = taskCompletedCount
        }
        if taskCount != nil{
            dictionary["taskCount"] = taskCount
        }
        return dictionary
    }
}

struct Schema {
    
    var marks : [Mark]!
    var type : String!      // image/vedio
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        marks = [Mark]()
        if let marksArray = dictionary["marks"] as? [[String:Any]]{
            for dic in marksArray{
                let value = Mark(fromDictionary: dic)
                marks.append(value)
            }
        }
        type = dictionary["type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if marks != nil{
            var dictionaryElements = [[String:Any]]()
            for marksElement in marks {
                dictionaryElements.append(marksElement.toDictionary())
            }
            dictionary["marks"] = dictionaryElements
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}

struct Mark {
    
    var descriptionField : String!
    var key : String!       // 人脸/汽车
    var name : String!
    var type : String!      // 形状
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        descriptionField = dictionary["description"] as? String
        key = dictionary["key"] as? String
        name = dictionary["name"] as? String
        type = dictionary["type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if key != nil{
            dictionary["key"] = key
        }
        if name != nil{
            dictionary["name"] = name
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}
