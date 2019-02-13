//
//  UnfoldFormRowView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/15.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

// section1 - subview
// 单行表单
class UnfoldCellTopViewFormRowView: UIView {

    var leftTitle: String = "" {
        willSet {
            leftGrid.title = newValue
        }
    }
    var leftValue: String = "" {
        willSet {
            leftGrid.value = newValue
        }
    }
    var rightTitle: String = "" {
        willSet {
            rightGrid.title = newValue
        }
    }
    var rightValue: String = "" {
        willSet {
            rightGrid.value = newValue
        }
    }
    
    private let leftGrid = UnfoldFormGridView()
    private let rightGrid = UnfoldFormGridView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        setupSubviews()
        setupLayouts()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupSubviews() {
        addSubview(leftGrid)
        addSubview(rightGrid)
    }
    
    private func setupLayouts() {
        leftGrid.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(self.snp.centerX)
            make.width.equalTo(rightGrid)
        }
        
        rightGrid.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(leftGrid.snp.right)
        }
        
    }
}

fileprivate class UnfoldFormGridView: UIView {
    
    var title: String = "" {
        willSet {
            self.titleLabel.text = newValue
        }
    }
    
    var value: String = "" {
        willSet {
            self.numLabel.text = newValue
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textColor = UIColor.gray
        return lab
    }()
    private lazy var numLabel: UILabel = {
        let lab = UILabel()
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupLayouts()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(numLabel)
    }
    
    private func setupLayouts() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(-5)
        }
        numLabel.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}
