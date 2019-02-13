//
//  MarkListFoldView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/14.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import FoldingCell
import SnapKit
import Then

/// mark cell open state view
class MarkJobFoldView: RotatedView {
    
    private let leftView = UIView()
    private let rightContentView = UIView()
    
    private let titleLabel = UILabel()
    private lazy var companyLabel : UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textColor = UIColor.gray
        return lab
    }()
    
    private lazy var rightBottomView: ColorStackView = {
        let containerView = ColorStackView()
        containerView.axis = .horizontal
        containerView.distribution = .fillEqually
        containerView.spacing = 10
        containerView.alignment = .fill
        containerView.addArrangedSubview(self.jobView)
        containerView.addArrangedSubview(self.priceView)
        containerView.addArrangedSubview(self.joinPersonView)
        return containerView
    }()
    
    private let jobView = FoldTitleView().then {
        $0.title = "剩余任务"
    }
    private let priceView = FoldTitleView().then {
        $0.title = "奖励"
    }
    private let joinPersonView = FoldTitleView().then {
        $0.title = "参与人数"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white

        setupSubviews()
        setupLayouts()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: PageListItem) {
        titleLabel.text = model.name
        companyLabel.text = model.creatorName
        jobView.value = String(model.remainCount)
        priceView.value = String(model.price)
        joinPersonView.value = String(model.joinPersonCount)
    }
    
    private func setupSubviews() {
        // right top
        rightContentView.addSubview(titleLabel)
        rightContentView.addSubview(companyLabel)
        rightContentView.addSubview(rightBottomView)
        
        addSubview(leftView)
        addSubview(rightContentView)
    }
    
    private func setupLayouts() {
        
        leftView.backgroundColor = UIColor("#02B241")
        
        leftView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        rightContentView.snp.makeConstraints { (make) in
            make.left.equalTo(leftView.snp.right)
            make.top.bottom.right.equalToSuperview()
        }
        
        let leftPadding = 20
        let topPadding = 20
        let midPadding = 10
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(leftPadding)
            make.top.equalToSuperview().offset(topPadding)
            make.right.equalToSuperview()
        }
        companyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(midPadding)
            make.right.equalToSuperview()
        }
        
        rightBottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(companyLabel.snp.bottom).offset(midPadding)
        }
    }
}

fileprivate class FoldTitleView: UIView {
    
    // label 文字居中
    private lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textColor = UIColor.gray
        return lab
    }()
    private lazy var numLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textColor = UIColor.gray
        return lab
    }()
    
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
            make.left.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        numLabel.snp.makeConstraints { (make) in
            make.left.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
}
