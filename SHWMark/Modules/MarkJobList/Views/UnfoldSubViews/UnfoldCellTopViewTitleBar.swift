//
//  UnfoldTitleBar.swift
//  SHWMark
//
//  Created by yehot on 2017/11/15.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SnapKit

// section1 - subview
// title view
class UnfoldCellTopViewTitleBar: UIView {

    let leftImageView: UIImageView = UIImageView()

    private lazy var titleLabel : UILabel = {
        let lab = UILabel()
//        lab.font = UIFont.systemFont(ofSize: 12)
        lab.textColor = UIColor.white
        lab.textAlignment = .center
        return lab
    }()
    
    private lazy var shareBtn: UIButton =  {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: "test_share_btn"), for: .normal)
        btn.addTarget(self, action: #selector(onShareClick), for: .touchUpInside)
        return btn
    }()
    
    var title: String = "" {
        willSet {
            self.titleLabel.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor("#02B241")
        leftImageView.image = UIImage.init(named: "test_img_src")
        
        setupSubviews()
        setupLayouts()
        setupData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData() {

    }
    
    private func setupSubviews() {
        addSubview(leftImageView)
        addSubview(titleLabel)
        addSubview(shareBtn)
    }
    
    private func setupLayouts() {
        
        leftImageView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.height)
            make.top.bottom.left.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(shareBtn.snp.left)
        }
        
        shareBtn.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
        }
    }

    // MARK: - actions
    @objc func onShareClick() {
        let image = UIImage.init(named: "AppIcon-60@3x")
        //MARK: 描述及图片
        self.shareUrl("标注分享", "描述一下", image!, "http://www.baidu.com") { (succeeded) in
            print("onShareClick callback")
        }
        print("onShareClick")
    }
    
    func shareUrl(_ title: String, _ desc: String, _ image: UIImage, _ url: String, completion: ((_ succeeded: Bool) -> Void)? = nil) {
//        if UMSocialManager.default().isInstall(.sina) {
//            UMSocialManager.default().setPlaform(.sina, appKey: "2084662894", appSecret: "57c5baf82d577ae3659b1c26d5a5b1d8", redirectURL: nil)
//        }else {
//            UMSocialManager.default().removePlatformProvider(with: .sina)
//        }
//        
//        //显示分享面板
//        UMSocialUIManager.showShareMenuViewInWindow { (platformType, userInfo) in
//            
//            //创建分享消息对象
//            let messageObject = UMSocialMessageObject()
//            //分享消息对象设置分享内容对象
//            let shareObject = UMShareWebpageObject.shareObject(withTitle: title, descr: desc, thumImage: image)!
//            //设置网页地址
//            shareObject.webpageUrl = url
//            messageObject.shareObject = shareObject
//            
//            //调用分享接口
//            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: nil, completion: { (data, error) in
//                if error != nil {
//                    print(error!.localizedDescription)
//                }
//                completion?(error == nil)
//            })
//        }
    }
}
