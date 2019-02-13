//
//  ZoomScrollView.swift
//  SHWMark
//
//  Created by yehot on 2017/11/2.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

// 标注编辑页 contentView
class ZoomScrollView: UIScrollView, UIScrollViewDelegate, MarkEditAble {

    private lazy var canvasView: CanvasImageView =  CanvasImageView.init(image: nil, brush: brushColor, selectedType: selectedMarkType)
    
    var markUndoManager: MarkUndoManager {
        return self.canvasView.markUndoManager
    }
    
    private lazy var currentZoomScale: CGFloat = {
        return self.maximumZoomScale
    }()
    
    private var brushColor: UIColor
    private var selectedMarkType: MarkLayerType

    // MARK: - life cycle
    init(brush: UIColor, selectedType: Mark) {
        brushColor = brush
        selectedMarkType = MarkLayerType.init(task: selectedType.key, shape: selectedType.type)

        super.init(frame: .zero)
        setupConfig()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCurrentType(mark: Mark, brush: UIColor) {
        let type = MarkLayerType.init(task: mark.key, shape: mark.type)
        canvasView.updateCurrentType(type: type, brush: brush)
    }
    
    private func setupConfig() {
        self.backgroundColor = UIColor.white
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.scrollsToTop = false
        self.delaysContentTouches = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        self.delegate = self;
        self.panGestureRecognizer.minimumNumberOfTouches = 2        
    }

    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        self.centerCanvasImageView()
    }
    
    // MARK: - pubilc
    /// set content image
    public func display(image: UIImage) {
        canvasView.removeFromSuperview()
        
        self.zoomScale = 1.0
        self.contentInset = UIEdgeInsets.zero

        let canvasW = self.frame.size.width
        let canvasH = image.size.height / image.size.width * canvasW
        canvasView = CanvasImageView.init(image: image, brush: brushColor, selectedType: selectedMarkType)
        canvasView.isUserInteractionEnabled = true
        canvasView.frame = CGRect.init(x: 0, y: 0, width: canvasW, height: canvasH)
        self.addSubview(canvasView)
        
        let zoomScales = self.getMaxAndMinZoomScales(with: canvasView.frame.size)
        self.maximumZoomScale = zoomScales.maxScale
        self.minimumZoomScale = zoomScales.minScale // always 1.0 ??
    }
    
    // MARK: - <MarkEditAble>
    public func undo() {
        canvasView.undo()
    }
    
    public func redo() {
        canvasView.redo()
    }
    
    public func removeAll() {
        canvasView.removeAll()
    }
    
    public func getAllMarkInfo() -> [MarkResult] {
        let markArray = canvasView.getAllMarkInfo()
        let array = markArray.map({ (mResult) -> MarkResult in
            // 转换标注结果，需要乘以 ScrollView 的缩放系数
            let _rect = mResult.rect.zoomScale(self.currentZoomScale)
            return MarkResult.init(rect: _rect, type: mResult.type)
        })
        return array
    }
    
    // MARK: - <UIScrollViewDelegate>
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvasView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerCanvasImageView()
    }

    // MARK: - private
    private func centerCanvasImageView() {
        let scrollerBoundsSize = self.bounds.size
        var imageViewframe = canvasView.frame
        
        if imageViewframe.size.width > scrollerBoundsSize.width {
            imageViewframe.origin.x = 0
            if !canvasView.frame.equalTo(imageViewframe) {
                canvasView.frame = imageViewframe
            }
        } else {
            canvasView.center = CGPoint.init(x: self.center.x, y: canvasView.center.y)
        }
        
        if imageViewframe.height <= scrollerBoundsSize.height {
            canvasView.center = CGPoint.init(x: canvasView.center.x, y: self.center.y)
        }
        self.contentSize = imageViewframe.size
    }
    
    private func getMaxAndMinZoomScales(with imageSize: CGSize) -> (maxScale: CGFloat, minScale: CGFloat) {
        let boundsSize = self.bounds.size
        let xScale = boundsSize.width / imageSize.width
        let yScale = boundsSize.height / imageSize.height
        
        var minScale = min(xScale, yScale)
        var maxScale = max(xScale, yScale)
        let xImageScale = maxScale * imageSize.width / boundsSize.width
        let yImageScale = maxScale * imageSize.height / boundsSize.height
        maxScale = max(maxScale, xImageScale, yImageScale, minScale)
        if minScale > maxScale {
            minScale = maxScale
        }
        return (maxScale, minScale)
    }
}

/// max of four Value
public func max<T>(_ x: T, _ y: T, _ z: T, _ n: T) -> T where T : Comparable {
    return max(max(max(x, y), z), n)
}
