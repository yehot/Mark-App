//
//  swift
//  SHWMark
//
//  Created by yehot on 2017/11/7.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SnapKit
import APIKit
import Kingfisher
import SwifterSwift
import Then
import NVActivityIndicatorView

class MarkEditViewController: UIViewController, NVActivityIndicatorViewable {

    // TODO: topToolBar 和 4 个按钮，抽取到到单独的 view 中
    lazy var undoButton: UIButton = {
        return UIButton.init(image: "edit_undo", target: self, action: #selector(onUndoClick))
    }()
    lazy var redoButton: UIButton = {
        return UIButton.init(image: "edit_redo", target: self, action: #selector(onRedoClick))
    }()
    lazy var closeButton: UIButton = {
        return UIButton.init(image: "edit_close", target: self, action: #selector(onCloseClick))
    }()
    lazy var doneButton: UIButton = {
        // TODO: 发生标记时，才能点击
        return UIButton.init(image: "edit_done", target: self, action: #selector(onDoneClick))
    }()
    lazy var topToolBar: ColorStackView = {
        let containerView = ColorStackView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 100))
        containerView.backgroundColor = UIColor("#282828")
        containerView.axis = .horizontal
        containerView.distribution = .fillEqually
        containerView.spacing = 20
        containerView.alignment = .fill
        containerView.addArrangedSubview(self.closeButton)
        containerView.addArrangedSubview(self.undoButton)
        containerView.addArrangedSubview(self.redoButton)
        containerView.addArrangedSubview(self.doneButton)
        return containerView
    }()

    lazy var bottomToolBar: MarkEditBottomTypeBar = {
        let containerView = MarkEditBottomTypeBar.init(frame: CGRect.init(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60))
        containerView.delegate = self
        return containerView
    }()
    
    lazy var canvasContentView: ZoomScrollView = {
        let color = MarkJobColor.clolor0.rawValue
        let type = self.taskSchema.marks[0]
        let sView = ZoomScrollView.init(brush: color, selectedType: type)
        sView.frame = self.view.bounds
        return sView
    }()
    
    /// 当前正在标注的图片任务
    private var currentTaskModel: MarkTaskModel?
    
    private var projectID: Int
    private var taskSchema: Schema
    
    // MARK: - life cycle
    init(projectID: Int, types: Schema) {
        self.projectID = projectID
        self.taskSchema = types
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(canvasContentView)
        view.addSubview(topToolBar)
        view.addSubview(bottomToolBar)
    
        observeUndoManager()
        updateUndoAndRedoButtons()
        
        self.bottomToolBar.update(schema: self.taskSchema)

        // TODO: test code
        let test = UIImage.init(named: "test_img")
        self.canvasContentView.display(image: test!)
//        sendGetMarkTaskRequest()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - request
    private func sendGetMarkTaskRequest() {
        guard let token = AccountManager.shared.tocken  else {
            return
        }
        self.showActivityIndicatorView()

        let req = GetMarkTaskRequest.init(projectID: projectID, token: token)
        Session.send(req) { (result) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self.hideActivityIndicatorView()
            })
            switch result {
            case .success(let response):
                self.handleGetMarkTaskResponse(response)
                
            case .failure(let error):
                // TODO: 获取图片失败处理 (包括当前 project 标注完了)
                print("error: \(error)----\(result.error!)" )
            }
        }
    }
    
    private func handleGetMarkTaskResponse(_ response: GetMarkTaskResponse) {
        if response.code == 404 {
            // TODO: 待弹框处理
            print("没有更多图片了，待处理")
            return
        }
        guard let model = response.model else {
            return
        }
        guard let imgUrlStr = model.dataObj.imageUrl else {
            print("image url 异常")
            return
        }
        currentTaskModel = model // record
        
        print("---- imageUrl ----: \(imgUrlStr)")
        guard let url = URL.init(string: imgUrlStr) else {
            print("image url error")
            return
        }
        ImageDownloader.default.downloadImage(with: url) {
            (image, error, url, data) in
            if let img = image {
                self.canvasContentView.display(image: img)
            }
        }
    }
    
    
    private func sendSubmitTaskRequest() {
        
        guard let token = AccountManager.shared.tocken else {
            // not necessary: 没有 token（未登录的，不能到此页面）
            return
        }
        guard let currentTask = currentTaskModel else {
            // 没有拉取图片，不能提交(应该没有任何标注时，不能点击)
            return
        }
        
        guard let jsonString = getMarkResultJson() else {
            // TODO: 目前没有标注的不能提交
            return
        }
        
        // TODO: 必崩问题
        let req = SubmitTaskRequest.init(taskID: currentTask.id, resultJson: jsonString, action:  currentTask.action, token: token)
        Session.send(req) { (result) in
            switch result {
            case .success(let response):
                self.handleMarkTaskSubmitResponse(response)
                
            case .failure(let error):
                // TODO: 提交失败的处理
                print(error)
            }
        }
    }
    
    private func handleMarkTaskSubmitResponse(_ response: SubmitTaskResponse) {
        guard let _ = response.model?.taskResultJson else {
            print(" MarkTaskSubmitResponse data format error")
            return
        }
        // 提交成功，请求下一张图片
        self.sendGetMarkTaskRequest()
    }
    
    
    // MARK: - undo manager
    fileprivate func observeUndoManager() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoAndRedoButtons), name: .UndoManagerStateChangeNotification, object: nil)
    }
    
    @objc fileprivate func updateUndoAndRedoButtons() {
        let manager = canvasContentView.markUndoManager
        undoButton.isEnabled = manager.canUndo == true
        redoButton.isEnabled = manager.canRedo == true
    }
    
    // MARK: -  actions
    @objc private func onRedoClick() {
        canvasContentView.redo()
    }
    
    @objc private func onUndoClick() {
        canvasContentView.undo()
    }
    
    @objc private func onCloseClick() {
        let alertVC = UIAlertController.init(title: "提示", message: "是否确认关闭？", preferredStyle: .alert).then { (alert) in
            alert.addAction(title: "确定", style: .default) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(title: "取消", style: .cancel, handler: nil)
        }
        alertVC.show()
    }
    
    @objc private func onDoneClick() {
        let alertVC = UIAlertController.init(title: "提示", message: "是否确认提交？", preferredStyle: .alert).then { (alert) in
            alert.addAction(title: "确定", style: .default) { (_) in
                self.sendSubmitTaskRequest()
            }
            alert.addAction(title: "取消", style: .cancel, handler: nil)
        }
        alertVC.show()
    }
    
    // MARK: - private
    private func getMarkResultJson() -> String? {
        let infoArray = canvasContentView.getAllMarkInfo()
        guard infoArray.count > 0 else {
            print("empty array")
            // TODO: 没有任何标注情况处理：有可能是图片上没有任何可标注的信息，也可能是 误操作 或 故意一直点
            return nil
        }
        guard let jsonString = MarkResult.jsonStringWithMarkResultArray(infoArray) else {
            print("parse MarkResultArray to json String error")
            return nil
        }
        return jsonString
    }
    
    private func showActivityIndicatorView(title: String = "Loading...") {
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: title, type: .ballPulse)
    }
    
    private func hideActivityIndicatorView() {
        self.stopAnimating()
    }
}

extension MarkEditViewController: MarkTypeChoiceDelegate {
    func onMarkTypeChoice(index: Int) {
        let type = taskSchema.marks[index]
        let color = MarkJobColor.init(num: index).rawValue
        canvasContentView.setupCurrentType(mark: type, brush: color)
    }
}
