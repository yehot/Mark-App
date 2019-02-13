//
//  ProfileLoginHeaderView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/20.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SnapKit

/// 已登录
class ProfileLoginHeaderView: UIView {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var bobLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor("#282828")
        
        // temp
        headImageView.backgroundColor = UIColor.white
        headImageView.layer.cornerRadius = 50
    }
    
    func updateUserInfo(user: User) {
        nickLabel.text = AccountManager.shared.currentUser.phoneNum        
        bobLabel.text = AccountManager.shared.currentUser.userID
    }
}
