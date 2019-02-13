//
//  MarkJobCell.swift
//  SHWMark
//
//  Created by yehot on 2017/11/13.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import FoldingCell
import EasyPeasy

// MARK: -  const
extension MarkJobCell {
    /// TODO: 翻转动画次数 (必须>=2)
    static let foldingAnimationCount = 5
    
    static let kCloseStateCellHeight = CGFloat(160)
    // TODO: 宽高比，待修改
    static let kOpenStateCellHeight = kCloseStateCellHeight * 3.5
    
    static let kCellID = "MarkJobCell"
    
    /// 每一个折叠动画的时间
    static let foldingAnimationDurations: [Double] = {
        var durations = [Double]()
        // 1. 变速
        durations = [0.12, 0.12, 0.1, 0.08, 0.06]
        if durations.count != foldingAnimationCount {
            fatalError("durations.count 必须 == foldingAnimationCount")
        }
        // 2. 匀速：
        //        for _ in 1...MarkJobCell.foldingAnimationCount {
        //            durations.append(0.1)
        //        }
        return durations
    }()
    
    /// 折叠动画总时间
    static let animationDuration: Double = {
        return MarkJobCell.foldingAnimationDurations.reduce(0, {
            $0 + $1
        })
    }()
}

class MarkJobCell: FoldingCell {

    private let _paddingTop: CGFloat = 8
    private let _paddingLeft: CGFloat = 20
    private var _closeViewHeight: CGFloat {
        return CGFloat(MarkJobCell.kCloseStateCellHeight - self._paddingTop * 2)
    }
    private var _openHeight: CGFloat {
        return CGFloat(MarkJobCell.kOpenStateCellHeight - self._paddingTop * 2)
    }
    
    private var _foldView = MarkJobFoldView()
    private var _unfoldView = MarkJobUnfoldView()
    
    var model: PageListItem? {
        didSet {
            _foldView.update(model: model!)
            _unfoldView.update(model: model!, isUnfolded: isUnfolded)
        }
    }
    
    func lazyLoadImage(_ model: PageListItem) {
        _unfoldView.lazyLoadImage(model)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor("#F5F5F5")
        // 翻转时的背景色
        backViewColor = UIColor("#A1D6AD")!
        itemCount = MarkJobCell.foldingAnimationCount
    
        setupSubViews()
        // super
        commonInit()  
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        _foldView = createCloseView()
        foregroundView = _foldView
        
        _unfoldView = createOpenView()
        containerView = _unfoldView
    }
    
    func configStartCallBack(_ callback: @escaping (PageListItem) -> ()) {
        self._unfoldView.startBtnCallBack = callback
    }
    
    // super
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        return MarkJobCell.foldingAnimationDurations[itemIndex]
    }
}

// MARK: - subViews
extension MarkJobCell {
    
    // close view 必须是 RotatedView
    private func createCloseView() -> MarkJobFoldView {
        let foregroundView = MarkJobFoldView.init(frame: .zero)
        contentView.addSubview(foregroundView)
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        
        foregroundView.easy.layout([
            Height(CGFloat(_closeViewHeight)),
            Left(_paddingLeft),
            Right(_paddingLeft),
            ])
        let top = foregroundView.easy.layout([Top(_paddingTop)]).first
        self.foregroundViewTop = top // important
        
        foregroundView.layoutIfNeeded()
        return foregroundView
    }
    
    private func createOpenView() -> MarkJobUnfoldView {
        let containerView = MarkJobUnfoldView.init(frame: .zero)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.easy.layout([
            Height(_openHeight),
            Left(_paddingLeft),
            Right(_paddingLeft),
            ])
        let top = containerView.easy.layout([Top(0)]).first
        self.containerViewTop = top // important
        
        containerView.layoutIfNeeded()
        return containerView
    }
}
