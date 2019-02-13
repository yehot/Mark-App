//
//  MarkJobListViewController.swift
//  SHWMark
//
//  Created by yehot on 2017/11/13.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import FoldingCell
import APIKit
import MJRefresh
import SwiftyJSON

class MarkJobListViewController: UITableViewController {

    // const
    private let kMarkJobCellID = MarkJobCell.kCellID
    private let kCloseCellHeight: CGFloat = MarkJobCell.kCloseStateCellHeight
    private let kOpenCellHeight: CGFloat = MarkJobCell.kOpenStateCellHeight
    // SkeletonCell
    private let kMarkJobSkeletonCellID = MarkJobSkeletonCell.kCellID
    private let kSkeletonCellCount = 8
    private let kSkeletonCellHeight: CGFloat = 100

    lazy var dataSource: [PageListItem] = []
    
    lazy var rightNavBtn : UIBarButtonItem = {
        let btn = UIButton.init(title: "", target: self, action: #selector(rightBtnClick))
        btn.setImage(UIImage.init(named: "test_more_btn"), for: .normal)
        btn.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        btn.adjustsImageWhenHighlighted = false
        return UIBarButtonItem.init(customView: btn)
    }()
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
//        requestMarkList()
        loadLocalTestData();
    }
    
    private func loadLocalTestData() {
        // 测试
        let path = Bundle.main.path(forResource: "mock_home_page_data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        func convertToDictionary(data: Data) -> [String: Any]? {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let jsonObj = try JSON(data: data)
            let jsonDict = jsonObj.dictionaryObject
            
            guard let dict = jsonDict else {
                return
            }
            let testModel = MarkListModel(fromDictionary: dict);
            handleMarkListResponse(testModel);
        } catch let error as Error? {
            print("读取本地数据出现错误!", error!)
        }
    }
    
    private func setupSubviews() {
        self.view.backgroundColor = UIColor.gray
        self.title = "标注"
        self.navigationItem.rightBarButtonItem = rightNavBtn

        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor("#F5F5F5")
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MarkJobCell.self, forCellReuseIdentifier: kMarkJobCellID)
        tableView.register(UINib.init(nibName: "MarkJobSkeletonCell", bundle: nil), forCellReuseIdentifier: kMarkJobSkeletonCellID) // SkeletonCell
        // TODO: 上下拉的实现
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self?.tableView.mj_header.endRefreshing()
            })
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self?.tableView.mj_footer.endRefreshing()
                self?.tableView.mj_footer = nil
            })
        })
    }
    
    // MARK: - request
    private func requestMarkList(page: Int = 1, size: Int = 20) {
        let markReq = MarkListRequest(page: page)
        Session.send(markReq) { (result) in
            switch result {
            case .success(let model):
                self.handleMarkListResponse(model)
            case .failure(let error):
                print("error: \(error)")
            }
        }
    }
    
    private func handleMarkListResponse(_ model: MarkListModel) {
        // TODO: 根据上拉或者下拉，追加数据，或者重置数据，而非赋值
        for obj in model.pageList {
            obj.openHeight = self.kOpenCellHeight
        }
        self.dataSource = model.pageList
        self.tableView.reloadData()
    }
    
    // MARK: - actions
    @objc func rightBtnClick() {
        self.navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
    
    func onStartButtonClick(model: PageListItem) {
//        guard AccountManager.shared.isLoggedIn() == true else {
//            let loginVC = LoginViewController.instantiate()
//            self.navigationController?.present(loginVC, animated: true, completion: nil)
//            return
//        }
//        guard model.schemaObj.marks.count > 0 else {    // 测试环境，数据有异常
//            print("schemaObj.marks.count can not be 0")
//            return
//        }
        let vc = MarkEditViewController.init(projectID: model.id, types: model.schemaObj)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - <UITableViewDataSource>
extension MarkJobListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count > 0 {   // SkeletonCell
            return dataSource.count
        }
        return kSkeletonCellCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: kMarkJobCellID, for: indexPath) as! MarkJobCell
            cell.model = dataSource[indexPath.row]
            cell.configStartCallBack { [weak self] (model) in
                self?.onStartButtonClick(model: model)
            }
            return cell
        } else {    // SkeletonCell
            // 占位 view
            let cell = tableView.dequeueReusableCell(withIdentifier: kMarkJobSkeletonCellID, for: indexPath) as! MarkJobSkeletonCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard dataSource.count > 0 else {   // SkeletonCell
            return kSkeletonCellHeight
        }
        
        let model = dataSource[indexPath.row]
        if model.isOpening {    // open
            return model.openHeight
        } else {
            return kCloseCellHeight
        }
    }
}

// MARK: - <UITableViewDelegate>
extension MarkJobListViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource.count <= 0 {  // SkeletonCell
            return
        }

        let _cell = tableView.cellForRow(at: indexPath)
        guard case let cell as MarkJobCell = _cell else {
            return
        }
        
        if cell.isAnimating() {
            return
        }
        
        let needAnimate = true
        var duration = MarkJobCell.animationDuration
        
        // FIXME: 在上边已经有 cell 展开的情况下，如果滑动到下发，再展开新的 cell ，会闪烁
        let model = dataSource[indexPath.row]
        if model.isOpening {    // 打开  -> 关闭
            cell.unfold(false, animated: needAnimate, completion: nil)
        } else {
            cell.unfold(true, animated: needAnimate, completion: nil)
            // NOTE: 展开时，再懒加载 view3 的缩略图
            cell.lazyLoadImage(dataSource[indexPath.row])
            duration = duration / 1.5   // 展开时，速度需要稍快点
        }
        model.isOpening = !model.isOpening

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    // NOTE: 必须在 willDisplay 时重置状态，否则会出现复用问题
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as MarkJobCell = cell else {
            return
        }
        guard dataSource.count > 0 else {  // SkeletonCell
            return
        }
        let model = dataSource[indexPath.row]
        if model.isOpening { // open
            cell.unfold(true, animated: false, completion: nil)
        } else { // close
            cell.unfold(false, animated: false, completion: nil)
        }
    }
}
