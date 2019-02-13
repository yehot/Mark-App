//
//  MarkThumbnailView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/24.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import Then
import SnapKit
import Kingfisher

// section3
// 缩略图 view
class MarkThumbnailView: UIView {
    private let titleLabel = UILabel().then { (label) in
        label.text = "任务描述"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
    }
    
    private let descriptionLabel = UILabel()
    
    private let imageStackView = UIStackView().then { (stack) in
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 30
        stack.alignment = .fill
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
        addSubview(descriptionLabel)
        addSubview(imageStackView)
    }
    private func setupLayouts() {
        let _paddingLeft: CGFloat = 20

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(_paddingLeft)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-_paddingLeft)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        
        imageStackView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.width.lessThanOrEqualTo(titleLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func update(_ model: PageListItem, isUnfold: Bool) {
        if model.media == "IMAGE" {
//            print("图片类型标注")
        }
        
        if let des = model.descriptionField {
            descriptionLabel.text = des
        }
        
        guard let array = model.medias else { // 测试数据有问题
            print("json nil type")
            return
        }
        
        for view in imageStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        var i = 0
        for _ in array {

            let imgView = UIImageView()
            i = i + 1

            // TODO: 优化点，展开时，才开始加载图片
            if isUnfold {
                let url = URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher/master/images/kingfisher-\(i + 1).jpg")!
//                print("图片 url: \(imgUrl)")
                imgView.kf.setImage(with: url)
                imgView.kf.indicatorType = .activity
            }
            imageStackView.addArrangedSubview(imgView)
        }
        
        let imgW = 90
        let width = imgW * i + (i - 1) * 20
        imageStackView.snp.remakeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(imgW)

            make.width.equalTo(width)
        }
    }
}
