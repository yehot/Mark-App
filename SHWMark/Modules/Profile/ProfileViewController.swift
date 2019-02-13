//
//  ProfileViewController.swift
//  SHWMark
//
//  Created by yehot on 2017/11/15.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
import SnapKit
//import SHWAccountSDK

class ProfileViewController: UIViewController {
    
    private lazy var _unLoginheaderView = ProfileUnLoginHeaderView()
    private lazy var _loginheaderView: ProfileLoginHeaderView = {
        let v = Bundle.main.loadNibNamed("ProfileLoginHeaderView", owner: self, options: nil)?.first as! ProfileLoginHeaderView
        return v
    }()

    private lazy var _tableView: UITableView = {
        let tabView = UITableView()
        tabView.delegate = self
        tabView.dataSource = self
        tabView.frame = self.view.bounds
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tabView.tableFooterView = UIView()
        tabView.separatorStyle = .none
        tabView.isScrollEnabled = false
        return tabView
    }()
    
    typealias model = (imgName: String, title: String)
    private lazy var dataSource: [model] = {
        return [
            // temp
            ("test_p_img_1", "新手指南"),
            ("test_p_img_2", "消息通知"),
            ("test_p_img_3", "意见反馈"),
            ("test_p_img_4", "关于"),
            ("test_p_img_4", "退出登录")
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "我的"
        
        view.addSubview(_tableView)
        
        _unLoginheaderView.onLoginButtonClickedCallback { [weak self] in
            let loginVC = LoginViewController.instantiate()
            loginVC.delegate = self
            self?.navigationController?.present(loginVC, animated: true, completion: nil)
        }
    }
    
    fileprivate func sendLogoutRequest() {
//        SHWAccountSDK.logoutAsync(success: {
//            AccountManager.shared.logout()
//            self._tableView.reloadData()
//        }) { (code, msg) in
//            print("log out faile")
//        }
    }
}

extension ProfileViewController: LoginSuccessDelegate {
    func loginSuccess() {
        _tableView.reloadData()
    }
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // temp
        if indexPath.row == (dataSource.count - 1) {
            sendLogoutRequest()
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let model = dataSource[indexPath.row]
        cell.imageView?.image = UIImage.init(named: model.imgName)
        cell.textLabel?.text = model.title
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if AccountManager.shared.isLoggedIn() == true {
            _loginheaderView.updateUserInfo(user: AccountManager.shared.currentUser)
            return _loginheaderView
        }
        return _unLoginheaderView
    }
}
