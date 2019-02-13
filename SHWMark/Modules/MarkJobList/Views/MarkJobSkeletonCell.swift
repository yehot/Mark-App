//
//  MarkJobSkeletonCell.swift
//  SHWMark
//
//  Created by yehot on 2017/11/27.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SkeletonView

class MarkJobSkeletonCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var txtLabel1: UILabel!
    @IBOutlet weak var txtLabel2: UILabel!
    @IBOutlet weak var txtLabel3: UILabel!
    
    static let kCellID = "MarkJobSkeletonCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        imgView.isSkeletonable = true
        imgView.showSkeleton()
        
        txtLabel1.isSkeletonable = true
        txtLabel1.showSkeleton()
        
        txtLabel2.isSkeletonable = true
        txtLabel2.showSkeleton()
        
        txtLabel3.isSkeletonable = true
        txtLabel3.showSkeleton()
    }
    
}

