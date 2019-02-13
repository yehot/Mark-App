//
//  UnfoldCellTypeView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/23.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import Then
import SnapKit
import FoldingCell

// section2
//  需要标注的类型
// TODO: 高度需要由 标注类型的数量动态变化?
class UnfoldCellTypeView: UIView {

    private let titleLabel = UILabel().then { (label) in
        label.text = "需要标注"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
    }
    
    private let typeStackView = UIStackView().then { (stack) in
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
    }
    
    private let bottomLine = UIView().then { (view) in
        view.backgroundColor = UIColor("#E1E1E1")
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
        addSubview(titleLabel)
        addSubview(typeStackView)
        addSubview(bottomLine)
    }
    private func setupLayouts() {
        
        let _paddingLeft: CGFloat = 20

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(_paddingLeft)
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        typeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(_paddingLeft)
            make.right.equalToSuperview().offset(-_paddingLeft)
//            make.bottom.equalToSuperview().offset(-2)
            make.bottom.lessThanOrEqualToSuperview().offset(-5)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.width.bottom.equalToSuperview()
        }
    }

    func update(_ model: PageListItem) {
        for view in typeStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for (index, markObj) in model.schemaObj.marks.enumerated() {
            let typeView = MarkTypeView()
            let mColor = MarkJobColor.init(num: index).rawValue
            typeView.update(mark: markObj, color: mColor)
            typeStackView.addArrangedSubview(typeView)
        }
    }

}
