//
//  MarkUndoManager.swift
//  SHWMark
//
//  Created by yehot on 2017/11/12.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import Foundation

// undo manager
extension Notification.Name {
    static let UndoManagerStateChangeNotification = Notification.Name("SHW_UndoManagerStateNotification")
}

// NOTE: 命名上需要注意的坑：
// UIResponder 有个 undoManger 的 属性，需要避免重复导致 bug
class MarkUndoManager {
    
    typealias rectArray = [RectangleLayer]
    
    private lazy var undoStack: [rectArray] = {
        return []
    }()
    private lazy var redoStack: [rectArray] = {
        return []
    }()
    
    var undoElement: rectArray {
        let arrayCount = self.undoStack.count
        // undo 时，取出 倒数第二个元素，重新绘制到界面上
        //  最后一个元素，放入 redoStack
        if arrayCount > 1 {
            return self.undoStack[arrayCount - 2]
        }
        return []
    }
    var redoElement: rectArray {
        let arrayCount = self.redoStack.count
        // redo 时，直接取出最后一个元素绘制，并放入到 undoStack
        if arrayCount > 0 {
            return self.redoStack[arrayCount - 1]
        }
        return []
    }
    
    var canUndo: Bool {
        return undoStack.count > 0
    }
    var canRedo: Bool {
        return redoStack.count > 0
    }
    
    /// 点击 redo 时（必须放在动作完成后，再记录）
    func recordUndoClick() {
        // 从 undoStack 中移出最后一个，放入 redoStack
        if let last = undoStack.last {
            redoStack.append(last)
            undoStack.removeLast()
        }
    }
    
    /// 必须放在动作完成后，再记录
    func recordRedoClick() {
        // 从 redoStack 中移出最后一个，放入 undoStack
        if let last = redoStack.last {
            undoStack.append(last)
            redoStack.removeLast()
        }
    }
    
    func addUndo(array: rectArray) {
        // TODO: 是否需要在这里 clone？？
        undoStack.append(deepCopy(array: array))
        redoStack.removeAll()
    }
    
//    redo 一定是由 undo 触发的，不用外界调用
//    func addRedo(array: rectArray) {
//        redoStack.append(array)
//    }
    
    func removeAllActions() {
        undoStack.removeAll()
        redoStack.removeAll()
    }
    
    // MARK: - private
    private func deepCopy(array: rectArray) -> rectArray {
        var deepArr = [RectangleLayer]()
        for item in array {
            let copyItem = item.copy() as! RectangleLayer
            deepArr.append(copyItem)
        }
        return deepArr
    }

}

