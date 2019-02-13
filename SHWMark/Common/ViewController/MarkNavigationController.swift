//
//  MarkNavigationController.swift
//  SHWMark
//
//  Created by yehot on 2017/11/15.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

class MarkNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 当 image 中包含 alpha 值时，会导致滑动返回时的偏移现象
//        let bgImage = UIImage.init(color: UIColor("#282828")!)
//        self.navigationBar.setBackgroundImage(bgImage, for: .default)
        
        self.navigationBar.barTintColor = UIColor.black
        
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
        ]
//        self.navigationBar.shadowImage = UIImage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
