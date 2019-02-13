//
//  RectangleLayer.swift
//  SHWMark
//
//  Created by yehot on 2017/10/31.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

/// 标注的矩形框
//class RectangleLayer: MarkShapeLayer {
class RectangleLayer: CAShapeLayer, NSCopying {
    
    /**
     矩形边框的 frame. 绘制本身并没有改变 Layer 的 frame，只是在 修改 layer.path.
     > 没有直接用 layer.frame 进行绘制的原因：
        1. 用了 layer.frame，只是限定了矩形边界，需要绘制特殊形状时，还是依赖 UIBezierPath
        2. 当前的 layer 不能使用修改 frame 的方式进行动画，layer 的显式动画需要重载 `init(layer:)`
            - 否则会 crash 在 Fatal error: Use of unimplemented initializer 'init(layer:)'
            - 而由于 RectangleLayer 初始化需要必要参数，无法在不传参情况下重载 init(layer:) 方法
            - 参见： https://www.jianshu.com/p/20ca067dad94
     */
    public var pathFrame: CGRect
    
    // NOTE: 新增的寸纯属性，必须需同步添加到 copy with zone 方法内
    private let brushColor: UIColor
    private let markType: MarkLayerType
    private let kLineWidth: CGFloat = 3
    
    /// firstTouchPoint 作为 origin point
    let firstTouchPoint: CGPoint
    /// zoom 时，记录 touch begin 的初始 frame
    var zoomOriginRect: CGRect = CGRect.zero
    
    var markResult: MarkResult {
        return MarkResult(rect: self.pathFrame, type: markType)
    }
    lazy var selectedMaskLayer: MarkSelectedMaskLayer = {
        return MarkSelectedMaskLayer.init(rect: self.pathFrame)
    }()

    public var isSelected: Bool = false {
        didSet {
            if isSelected {
                self.bringToFront()
                self.addSublayer(selectedMaskLayer)
            } else {
                selectedMaskLayer.removeFromSuperlayer()
            }
        }
    }
    
    // MARK: - init
    init(point: CGPoint, type: MarkLayerType, brush: UIColor) {
        self.markType = type
        self.brushColor = brush
        self.firstTouchPoint = point
        self.pathFrame = CGRect.init(origin: point, size: CGSize.init(width: 0, height: 0))

        super.init()
        
        self.lineWidth = kLineWidth
        // 设置 fill color 为透明不够展示的矩形，仍是实心矩形
        self.fillColor = UIColor.clear.cgColor
        self.strokeColor = brush.cgColor
        
        self.path = UIBezierPath.init(rect: self.pathFrame).cgPath
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - <NSCopying>
    // MARK: 新增属性，必须手动同步到 copy with zone 方法内！！
    //       否则 undo redo 无法正常生效
//    override func copy(with zone: NSZone? = nil) -> Any {
    func copy(with zone: NSZone? = nil) -> Any {
        let copySelf = RectangleLayer.init(point: self.firstTouchPoint, type: self.markType, brush: self.brushColor)
        copySelf.path = self.path
        copySelf.zPosition = self.zPosition
        copySelf.isSelected = self.isSelected
        copySelf.pathFrame = self.pathFrame
        return copySelf
    }
    
    // MARK: - edit actions
    // TODO: 选中状态下加一层 layer，在 move 和 zoom 时，不停 redraw 这层 layer
    public func move(to rect: CGRect) {
        self.pathFrame = rect
        self.path = UIBezierPath.init(rect: rect).cgPath;
        
        selectedMaskLayer.move(to: rect)
    }
    
    public func zoom(to rect: CGRect) {
        self.pathFrame = rect
        self.path = UIBezierPath.init(rect: rect).cgPath;
        
        selectedMaskLayer.zoom(to: rect)
    }
}

extension RectangleLayer {
    // TODO: touch 在 layer 上的相对位置 TouchPosition
    public func containsPoint(point: CGPoint) -> Bool {
        if let path = self.path {
            return path.contains(point)
        }
        return false        
    }
    public func isJustAPoint() -> Bool {
        return self.pathFrame.width <= 1 && self.pathFrame.height <= 1
    }
}
