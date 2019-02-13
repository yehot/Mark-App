//
//  MarkSelectedMaskLayer.swift
//  TestBezierPath
//
//  Created by yehot on 2018/1/4.
//  Copyright © 2018年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

class MarkSelectedMaskLayer: CALayer {
    
    private let radius: CGFloat = 6
    
    private var diameter: CGFloat {
        return radius * 2
    }
    private var leftTopRect: CGRect {
        return CGRect.init(x: -radius, y: -radius, width: diameter, height: diameter)
    }
    private var rightTopRect: CGRect {
        return CGRect.init(x: self.frame.width - radius, y: -radius, width: diameter, height: diameter)
    }
    private var rightBottomRect: CGRect {
        return CGRect.init(x: self.frame.width - radius, y: self.frame.height - radius, width: diameter, height: diameter)
    }
    private var leftBottomRect: CGRect {
        return CGRect.init(x: -radius, y: self.frame.height - radius, width: diameter, height: diameter)
    }
    // 四个顶点的 content layer
    private lazy var leftTopCircleLayer = MarkCornerCircleLayer.init(with: leftTopRect)
    private lazy var rightTopCircleLayer = MarkCornerCircleLayer.init(with: rightTopRect)
    private lazy var rightBottomCircleLayer = MarkCornerCircleLayer.init(with: rightBottomRect)
    private lazy var leftBottomCircleLayer = MarkCornerCircleLayer.init(with: leftBottomRect)
    
    // MARK: - init
    init(rect: CGRect) {
        super.init()
        
        self.frame = rect

        self.addSublayer(leftTopCircleLayer)
        self.addSublayer(rightTopCircleLayer)
        self.addSublayer(rightBottomCircleLayer)
        self.addSublayer(leftBottomCircleLayer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // must
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    // MARK: - public
    func move(to newRect: CGRect) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.frame = newRect
        CATransaction.commit()
    }
    
    func zoom(to newRect: CGRect) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.frame = newRect
        leftTopCircleLayer.move(to: leftTopRect)
        rightTopCircleLayer.move(to: rightTopRect)
        rightBottomCircleLayer.move(to: rightBottomRect)
        leftBottomCircleLayer.move(to: leftBottomRect)
        
        CATransaction.commit()
    }
}

fileprivate class MarkCornerCircleLayer: CAShapeLayer {
    
    let kFillColor = UIColor("#2196f3")!
    let kStokeColor = UIColor.white
    let kLineWidth: CGFloat = 3
    
    // MARK: - init
    init(with rect: CGRect) {
        super.init()
        
        self.frame = rect
        
        self.path = ovalPath(with: rect).cgPath
        
        self.fillColor = kFillColor.cgColor
        self.strokeColor = kStokeColor.cgColor
        self.lineWidth = kLineWidth
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // must
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    func move(to rect: CGRect) {
        self.frame = rect
        self.path = ovalPath(with: rect).cgPath
    }
    
    /// 绘制圆形 path
    private func ovalPath(with rect: CGRect) -> UIBezierPath {
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rect.width, height: rect.width))
        ovalPath.lineCapStyle = .round
        ovalPath.lineJoinStyle = .round
        return ovalPath
    }
}
