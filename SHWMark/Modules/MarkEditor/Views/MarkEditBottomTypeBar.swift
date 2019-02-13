//
//  MarkEditBottomTypeBar.swift
//  SHWMark
//
//  Created by yehot on 2017/12/6.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SnapKit
import Then

protocol MarkTypeChoiceDelegate: class {
    func onMarkTypeChoice(index: Int)
}

class MarkEditBottomTypeBar: UIView {
    
    weak var delegate: MarkTypeChoiceDelegate?

    private var schema: Schema?
    private let _kCellID = "MarkTypeCellID"
    private let _font = MarkTypeCell.font
    
    // const
    private let leftPadding: CGFloat = 10
    private let topPadding: CGFloat = 10
    private let maxItemCount = 5    // 最多 5 个 type
    
    // 记录当前选中的 index
    private var selectIndex = 0
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        collection.register(MarkTypeCell.self, forCellWithReuseIdentifier: _kCellID)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    private lazy var itemFrameArray: [CGSize] = {
        guard let marksArray = schema?.marks else {
            return [.zero]
        }
        var array = [CGSize]()
        for (index, mark) in marksArray.enumerated() {
            let _height = self.height - topPadding * 2
            let width = mark.name.textWidth(with: _font, constrainedToHeight: Double(height))
            // 左右留一定边距
            var _size = CGSize.init(width: width + leftPadding, height: _height)
            array.append(_size)
        }
        return array
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor("#282828")
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(schema: Schema) {
        self.schema = schema
        
        guard schema.marks.count > 0 else {
            return
        }
        // 默认选中第 0 个
        collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: false, scrollPosition: .left)
    }
}

// MARK: - <UICollectionViewDelegate>
extension MarkEditBottomTypeBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickIndex = indexPath.row
        selectIndex = clickIndex

        if let dele = self.delegate {
            dele.onMarkTypeChoice(index: clickIndex)
        }
    }
}

// UICollectionViewDelegateFlowLayout
extension MarkEditBottomTypeBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard itemFrameArray.count > 0 else {
            return .zero
        }
        return itemFrameArray[indexPath.row]
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return leftPadding
    }
}

// MARK: - <UICollectionViewDataSource>
extension MarkEditBottomTypeBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = schema?.marks.count else {
            return 0
        }
        return count
    }

    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: _kCellID, for: indexPath) as! MarkTypeCell

        cell.tag = index

        if let model = schema?.marks[index] {
            let bgColor = MarkJobColor.init(num: index).rawValue
            cell.update(titile: model.name, color: bgColor)
        }
        return cell;
    }
}

// MARK: - cell
class MarkTypeCell: UICollectionViewCell {
    
    static let font: UIFont = .systemFont(ofSize: 20)
    
    private let label = UILabel().then { (lab) in
        lab.textAlignment = .center
        lab.textColor = UIColor.white
        lab.font = MarkTypeCell.font
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue == true {
                self.layer.borderWidth = 3
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.shadowColor = UIColor.white.cgColor
        self.clipsToBounds = true
        
        self.contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(titile: String, color: UIColor) {
        label.text = titile
        label.backgroundColor = color
    }
}
