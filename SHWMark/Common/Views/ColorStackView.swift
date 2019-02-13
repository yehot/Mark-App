//
//  ColorStackView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/7.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/34868344/how-to-change-the-background-color-of-uistackview
// UIStackView 默认不能设置背景色
class ColorStackView: UIStackView {

    private var color: UIColor?
    override var backgroundColor: UIColor? {
        get { return color }
        set {
            color = newValue
            self.setNeedsLayout()
        }
    }
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.path = UIBezierPath(rect: self.bounds).cgPath
        backgroundLayer.fillColor = self.backgroundColor?.cgColor
    }

}
