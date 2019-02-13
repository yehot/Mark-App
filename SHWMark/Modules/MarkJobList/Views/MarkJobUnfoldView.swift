//
//  MarkJobUnfoldView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/15.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import FoldingCell
import EasyPeasy
import Then

/// mark cell close state view
class MarkJobUnfoldView: UIView {
    
    private let _paddingTop: CGFloat = 8
    private let _paddingLeft: CGFloat = 20
    
    private var _closeViewHeight: CGFloat {
        return CGFloat(MarkJobCell.kCloseStateCellHeight - self._paddingTop * 2)
    }
    private var _openHeight: CGFloat {
        return CGFloat(MarkJobCell.kOpenStateCellHeight - self._paddingTop * 2)
    }
    
    private lazy var topView = UnfoldCellTopView()
    private lazy var markTypeView = UnfoldCellTypeView()
    private lazy var thumbView = MarkThumbnailView()
    private lazy var bottomView: UIView = UIView()

    // bottomView sub
    private let startButton = UIButton().then { (btn) in
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.setTitle("开始", for: .normal)
        btn.backgroundColor = UIColor("#444444")
        btn.addTarget(self, action: #selector(onStartButtonClick), for: .touchUpInside)
    }
    private let countLabel = UILabel().then { (label) in
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.gray
    }

    // TODO: 改为 delegate
    typealias startBtnCallBack = (PageListItem) -> ()
    var startBtnCallBack: startBtnCallBack?
    private var model: PageListItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        setupSubviews()
        setupLayouts()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: PageListItem, isUnfolded: Bool) {
        self.model = model
        
        topView.update(model)
        markTypeView.update(model)
        thumbView.update(model, isUnfold: isUnfolded)
        
        // temp
        countLabel.text = "已标注 0 个"
    }

    func lazyLoadImage(_ model: PageListItem) {
        thumbView.update(model, isUnfold: true)
    }
    
    private func setupSubviews() {
        addSubview(topView)
        addSubview(markTypeView)
        addSubview(thumbView)
        addSubview(bottomView)
        
        // temp
        bottomView.addSubview(startButton)
        bottomView.addSubview(countLabel)
    }
    
    private func setupLayouts() {
        topView.snp.makeConstraints { (make) in
            make.top.left.width.equalToSuperview()
            // TODO: 高度问题
            make.height.equalTo(_closeViewHeight + 40)
        }
        
        markTypeView.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(_closeViewHeight - 40)
        }
        
        thumbView.snp.makeConstraints { (make) in
            make.left.width.equalToSuperview()
            make.top.equalTo(markTypeView.snp.bottom)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.width.bottom.equalToSuperview()
            make.height.equalTo(30 + 44)
        }
        
        // temp
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(44)
            make.right.equalToSuperview().offset(-30)
        }
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(startButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - actions
    @objc func onStartButtonClick() {
        if let callback = self.startBtnCallBack {
            callback(model!)
        }
    }
}
