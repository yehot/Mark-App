//
//  UnfoldCellTopView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/16.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import FoldingCell
import EasyPeasy
import Then

// section1
class UnfoldCellTopView: UIView {
    private let titleBar = UnfoldCellTopViewTitleBar()
    private let formLine1 = UnfoldCellTopViewFormRowView().then {
        $0.leftTitle = "创建人（组织）"
        $0.rightTitle = "奖励"
    }
    private let formLine2 = UnfoldCellTopViewFormRowView().then {
        $0.leftTitle = "开始时间"
        $0.rightTitle = "结束时间"
    }
    
    private lazy var lineView1 : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor("#F7F7F7")
        return v
    }()
    private lazy var lineView2 : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor("#E1E1E1")
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        setupSubviews()
        setupLayouts()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ model: PageListItem) {
        titleBar.title = model.name
        
        if let name = model.creatorName {
            formLine1.leftValue = name
        }
        formLine1.rightValue = String(model.price)
        
        formLine2.leftValue = model.startTimeYYMMDD
        formLine2.rightValue = model.endTimeYYMMDD
    }
    
    private func setupSubviews() {
        addSubview(titleBar)
        addSubview(formLine1)
        addSubview(formLine2)
        
        addSubview(lineView1)
        addSubview(lineView2)
    }
    private func setupLayouts() {
        
        let _paddingLeft: CGFloat = 20
        
        // view1 sub views
        titleBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        formLine1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(_paddingLeft)
            make.right.equalToSuperview().offset(-_paddingLeft)
            make.top.equalTo(titleBar.snp.bottom)
            make.height.equalTo(formLine2)
        }
        formLine2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(_paddingLeft)
            make.right.equalToSuperview().offset(-_paddingLeft)
            make.bottom.equalToSuperview()
            make.top.equalTo(formLine1.snp.bottom)
        }
        
        lineView1.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(_paddingLeft)
            make.right.equalToSuperview().offset(-_paddingLeft)
            make.bottom.equalTo(formLine1.snp.bottom)
        }
        // temp
        lineView2.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.width.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
