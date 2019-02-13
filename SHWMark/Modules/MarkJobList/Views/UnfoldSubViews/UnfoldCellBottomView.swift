//
//  UnfoldCellBottomView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/24.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import Then
import SnapKit

// section 4 - unuse now
class UnfoldCellBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupLayouts()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
//        addSubview(titleLabel)
//        addSubview(descriptionLabel)
    }
    private func setupLayouts() {
    }
    
    func update(_ model: PageListItem) {
    }

}
