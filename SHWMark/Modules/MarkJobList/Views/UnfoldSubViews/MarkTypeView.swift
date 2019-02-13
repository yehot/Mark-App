//
//  MarkTypeView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/23.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import Then
import SnapKit

// section2 - subview
class MarkTypeView: UIView {
    
    private let titleLabel = UILabel().then { (label) in
        label.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    // TODO: 左侧矩形，绘制出来
    private let typeRectView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupLayouts()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(mark: Mark, color: UIColor) {
        titleLabel.text = mark.name
        titleLabel.textColor = color
        
        typeRectView.layer.borderColor = color.cgColor
        typeRectView.layer.borderWidth = 2
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(typeRectView)
    }
    private func setupLayouts() {
        typeRectView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(typeRectView.snp.right).offset(10)
            make.right.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
