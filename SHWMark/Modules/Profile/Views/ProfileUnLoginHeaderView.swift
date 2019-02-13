//
//  ProfileUnLoginHeaderView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/20.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SnapKit

/// 未登录
class ProfileUnLoginHeaderView: UIView {

    private lazy var loginBtn: UIButton = {
        let btn = UIButton.init(title: "登录", textColor: .white, backColor: UIColor("#009688")!)
        btn.addTarget(self, action: #selector(onLoginClick), for: .touchUpInside)
        return btn
    }()
    
    typealias loginCallBackBlock = () -> ()
    private var loginCallback: loginCallBackBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor("#282828")
        
        addSubview(loginBtn)
        
        loginBtn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
    
    func onLoginButtonClickedCallback(_ callBack: @escaping loginCallBackBlock) {
        self.loginCallback = callBack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onLoginClick() {
        print("onLoginClick")
        if let callback = loginCallback {
            callback()
        }
    }
}
