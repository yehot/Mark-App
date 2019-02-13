//
//  CanvasView.swift
//  SHWMark
//
//  Created by yehot on 2017/10/31.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit

class CanvasImageView: UIImageView, MarkEditAble {

    public private(set) var brushColor: UIColor
    public private(set) var markType: MarkLayerType
    
    private var drawingLayer: RectangleLayer?
    private var selectedLayer: RectangleLayer?

    fileprivate lazy var layersArray = [RectangleLayer]()

    private(set) var markUndoManager = MarkUndoManager()

    private var touchesBeginPositionOnSelectedLayer: TouchPosition?
    
    private var hasMovedAfterFirstTouch = false
    private var hasSeletAndZoomAction = false

    private var touchBeginStamp: TimeInterval?
    private var touchEndStamp: TimeInterval?

    // MARK: - public
    init(image: UIImage?, brush: UIColor, selectedType: MarkLayerType) {
        markType = selectedType
        brushColor = brush
        super.init(image: image)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCurrentType(type: MarkLayerType, brush: UIColor) {
        brushColor = brush
        markType = type
    }
    
    // MARK: - <UITouch>
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard event?.isMultipleTouch == false, let touchBeganPoint = touches.first?.location(in: self) else {
            return
        }
        
        // 重置状态
        hasSeletAndZoomAction = false
        hasMovedAfterFirstTouch = false
        touchBeginStamp = touches.first?.timestamp
        
        if let select = selectedLayer {
            touchesBeginPositionOnSelectedLayer = TouchPosition.init(ofPoint: touchBeganPoint, inRect: select.pathFrame)
            selectedLayer?.zoomOriginRect = select.pathFrame
        }
        
        // TODO: 长按删除需要提示，不友好。待改为选中后才能删
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard self.touchBeginPositionInsideOfSelectedLayer else {
                return
            }
            if !self.hasMovedAfterFirstTouch && self.touchDuration > 0.5 {
                guard let selectLayer = self.selectedLayer, let selectedIndex = self.layersArray.index(of: selectLayer) else {
                    return
                }
                self.layersArray.remove(at: selectedIndex)
                self.reDraw(self.layersArray)
                
                self.markUndoManager.addUndo(array: self.layersArray)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        // FIXME: 矩形可以画出屏幕的问题。touch move 时，判断落点是否在当前屏幕内，不在，return
        guard event?.isMultipleTouch == false, let touchedPoint = touches.first?.location(in: self) else {
            return
        }
        hasMovedAfterFirstTouch = true

        if drawingLayer == nil {
            drawingLayer = RectangleLayer.init(point: touchedPoint, type: markType, brush: brushColor)
            self.layer.addSublayer(drawingLayer!)
        }
        
        if touchBeginPositionOutsideOfSelectedLayer {
            selectedLayer?.isSelected = false
            selectedLayer = nil
        }
        
        if let selectLayer = selectedLayer {  // 选中状态
            guard let touchBeginPosition = touchesBeginPositionOnSelectedLayer else {
                return
            }
            if touchBeginPosition == .Inside {    // 选中 -> 移动
                let prePoint = touches.first!.previousLocation(in: self)
                let newRect = selectLayer.pathFrame.move(from: prePoint, endPoint: touchedPoint)
                selectLayer.move(to: newRect)
            }  else {   // 选中 -> 编辑
                guard let rect = selectedLayer?.pathFrame else {
                    return
                }
                hasSeletAndZoomAction = true
                let newRect = rect.update(with: touchedPoint, in: touchBeginPosition, originRect: selectLayer.zoomOriginRect)
                selectLayer.zoom(to: newRect)
            }
        } else {    // 未选中状态 -> 绘制
            guard let drawLayer = drawingLayer else {
                return
            }
            let rect = CGRect.init(startPoint: drawLayer.firstTouchPoint, endPoint: touchedPoint)
            drawLayer.zoom(to: rect)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard event?.isMultipleTouch == false else {
            return
        }
        touchEndStamp = touches.first?.timestamp

        if hasMovedAfterFirstTouch {   // 编辑
            if !layersArray.contains(drawingLayer!) && !drawingLayer!.isJustAPoint() {
                layersArray.append(drawingLayer!)
            } else {
                drawingLayer?.removeFromSuperlayer()
            }
            markUndoManager.addUndo(array: layersArray)
            self.postNotify()
        } else {    // 点击
            if hasSeletAndZoomAction {
                // 有形变编辑，不反选 to fix: 编辑结束时，落点在其它 layer 区域内时， selectLyaer 会被反选
            } else {
                
                if touchBeginPositionOutsideOfSelectedLayer  {
                    selectedLayer?.isSelected = false
                    selectedLayer = nil
                }
                guard let currentPoint = touches.first?.location(in: self) else {
                    return
                }
                let tLayer: RectangleLayer? = queryFirstLayerInLayerArrayWhichBennTouched(currentPoint)
                guard let touchedLayer = tLayer else {
                    return
                }
                if touchedLayer == selectedLayer {
                    return
                }
                touchedLayer.isSelected = true
                selectedLayer = touchedLayer
                
                if let index = layersArray.index(of: touchedLayer) {
                    // 选中的 layer 置顶
                    layersArray.remove(at: index)
                    layersArray.append(touchedLayer)
                }
            }
        }
        drawingLayer = nil
    }
    
    // MARK: - private
    private func reDraw(_ layers: [RectangleLayer]) {
        self.layer.sublayers?.removeAll()
        
        self.layersArray = layers
        for rectLayer in layers {
//            if let select = selectedLayer { // reDraw 时，仍保持选中的 layer 的状态
//                if rectLayer.pathFrame.equalTo(select.pathFrame) {
//                    rectLayer.isSelected = true
//                    selectedLayer = rectLayer
//                }
//            }
            rectLayer.isSelected = false    // reDraw 时，暂时都反选
            self.layer.addSublayer(rectLayer)
        }
    }
}

// MARK: - <MarkEditAble>
extension CanvasImageView {
    
    public func undo() {
        guard markUndoManager.canUndo else {
            return
        }
        self.reDraw(markUndoManager.undoElement)

        markUndoManager.recordUndoClick()
        self.postNotify()
    }
    
    public func redo() {
        guard markUndoManager.canRedo else {
            return
        }
        self.reDraw(markUndoManager.redoElement)
        
        markUndoManager.recordRedoClick()
        self.postNotify()
    }
    
    public func removeAll() {
        self.layersArray.removeAll()
        self.layer.sublayers?.removeAll()
    }
    
    public func getAllMarkInfo() -> [MarkResult] {
        var array = [MarkResult]()
        for layer in layersArray {
            array.append(layer.markResult)
        }
        return array
    }
}

extension CanvasImageView {
    private var touchDuration: Double {
        if let sTime = touchBeginStamp, let endTime = touchEndStamp {
            return Double(sTime - endTime)
        }
        return 0
    }
    private func postNotify() {
        NotificationCenter.default.post(name:.UndoManagerStateChangeNotification, object: nil, userInfo:nil )
    }
}

// touch judge util
extension CanvasImageView {
    fileprivate var touchBeginPositionOutsideOfSelectedLayer: Bool {
        return touchesBeginPositionOnSelectedLayer == .Outside
    }
    fileprivate var touchBeginPositionInsideOfSelectedLayer: Bool {
        return touchesBeginPositionOnSelectedLayer == .Inside
    }
    fileprivate func queryFirstLayerInLayerArrayWhichBennTouched(_ point: CGPoint) -> RectangleLayer? {
        var touchedLayer: RectangleLayer? = nil
        for layer in layersArray.reversed() {
            if !layer.containsPoint(point: point) {
                continue
            }
            touchedLayer = layer
            break // to fix 点击重叠区域时，可能有多个符合
        }
        return touchedLayer
    }
}
