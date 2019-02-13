//
//  LoginViewController.swift
//  SHWMark
//
//  Created by yehot on 2017/11/13.
//  Copyright © 2017年 Xin Hua Zhi Yun. All rights reserved.
//

import UIKit
//import SHWAccountSDK
import RxSwift
import RxCocoa
import Toast_Swift

protocol LoginSuccessDelegate: class {
    func loginSuccess()
}

extension LoginViewController: StoryboardInstantiable {
    static var storyboardName: String { return "Login" }
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var smsCodeTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var smsCodeButton: UIButton!

    weak var delegate: LoginSuccessDelegate?

    lazy var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        setupSubViews()
        
        // MARK: 检测微博、qq是否登录
//        UMSocialManager.default().isInstall(.sina)
//        UMSocialManager.default().isInstall(.QQ)
        
        configViewModel()
        
    }
    
    func configViewModel() {

        let viewModel = LoginViewModel.init(input: (
            phone: phoneTextField.rx.text.orEmpty.asObservable(),
            smsCode: smsCodeTextField.rx.text.orEmpty.asObservable(),
            loginTap: loginButton.rx.tap.asObservable()))
        
        viewModel.validatedPhone
            .subscribe(onNext: { (phoneOK) in
                print(phoneOK)
            }).disposed(by: bag)
        
        viewModel.validatedSmsCode
            .subscribe(onNext: { (codeOK) in
                print(codeOK)
            }).disposed(by: bag)

        viewModel.loginBtnEnabled
            .bind(to: loginButton.rx.tapEnabled)
            .disposed(by: bag)
        
        // TODO: 点击后，60s 不可点逻辑处理
        viewModel.validatedPhone
            .bind(to: smsCodeButton.rx.tapEnabled)
            .disposed(by: bag)
    }
    
    func setupSubViews() {
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.borderStyle = .none
        phoneTextField.clearButtonMode = .whileEditing
        let btn = phoneTextField.value(forKey: "_clearButton") as? UIButton
        btn?.setImage(UIImage.init(named: "delete_icon"), for: .normal)
        phoneTextField.keyboardType = .numberPad
        
        smsCodeTextField.placeholder = "请输入验证码"
        smsCodeTextField.borderStyle = .none
        smsCodeTextField.keyboardType = .numberPad
        
        // rx subscribe
        phoneTextField.rx.text.orEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] (str) in
//                if str.length >= 11 {
//                    guard let `self` = self else {
//                        return
//                    }
//                    // 实现控制输入总长度的效果
//                    self.phoneTextField.text = str.subString(to: 11)
//                }
            }).disposed(by: bag)
    
        // orEmpty 作用： 将 optional 过滤掉
        smsCodeTextField.rx.text.orEmpty
            .asObservable()
            .subscribe(onNext: { [weak self] (str) in
//                if str.length >= 6 {
//                    guard let `self` = self else {
//                        return
//                    }
//                    self.smsCodeTextField.text = str.subString(to: 6)
//                }
            })
            .disposed(by: bag)
        
        loginButton.rx.tap
//            .asObservable() // 加不加都一样
            .subscribe(onNext: { [weak self] in
                guard let `self` = self, let phoneStr = self.phoneTextField.text, let smsCodeStr = self.smsCodeTextField.text else{
                    return
                }
                self.view.endEditing(true)
                self.sendLoginRequest(phone: phoneStr, smsCode: smsCodeStr)
            })
            .disposed(by: bag)
        
        smsCodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self, let phoneStr = self.phoneTextField.text else{
                    return
                }
//                SHWAccountSDK.getSMSCodeAsync(withPhoneNum: phoneStr, purpose: .register, success: { (state) in
//                    print("sms code ---\(state)")
//                }){ (code, msg) in
//                    print("\(String(describing: code))---\(String(describing: msg))")
//                }
            })
            .disposed(by: bag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    deinit {
        // NOTE: 较多使用 rx 的 closure ，注意防止内存泄露
        print("deinit ==============================")
    }
}

extension LoginViewController {
    @IBAction func onCloseClick(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - login request
extension LoginViewController {
    
    func sendLoginRequest(phone: String, smsCode: String) {
//        SHWAccountSDK.freePasswordLoginAsync(withPhoneNum: phone, smsCode: smsCode, success: { (userID, token) in
//            guard let userID = userID, let token = token else {
//                return
//            }
//            self.handleLoginResponse(userID: userID, phone: phone, token: token)
//            
//        }, failure: { (code, msg) in
//            guard let code = code, let msg = msg else {
//                return
//            }
//            self.view.makeToast("code: \(code) msg: \(String(describing: msg))", duration: 1.5, position: .center)
//        })
    }
    
    func handleLoginResponse(userID: String, phone: String, token: String) {
        //print(userID)
        
        AccountManager.shared.recordUserID(userID, phone: phone, token: token)
        AccountManager.shared.loginSuccess()
        
        self.view.makeToast("登录成功", duration: 0.25, position: .center) { [weak self] didTap in
            self?.dismiss(animated: true, completion: nil)
            if let delegate = self?.delegate {
                delegate.loginSuccess()
            }
        }
    }
}

// MARK: - social login
extension LoginViewController {
    
    @IBAction func onClickQQLogin(_ sender: UIButton) {
//        self.getUserInfoForPlatform(.QQ)
    }
    
    @IBAction func onClickWeiboLogin(_ sender: UIButton) {
//        self.getUserInfoForPlatform(.sina)
    }
    
    @IBAction func onClickWeiChatLogin(_ sender: UIButton) {
//        self.getUserInfoForPlatform(.wechatSession)
    }
    
//    private func getUserInfoForPlatform(_ platform : UMSocialPlatformType) {
//        UMSocialManager.default().getUserInfo(with: platform, currentViewController: self) { (result, error: Error?) in
//            // 数据回调，生命周期上晚于applciation openURL
//            if error != nil {
//                print("三方登录失败 error: \(error!)")
//                return
//            }
//            guard let infoResponse = result as? UMSocialUserInfoResponse else {
//                return
//            }
////            print("uid: \(infoResponse.uid), openId: \(infoResponse.openid), unionid : \(infoResponse.unionId), accessToken, \(infoResponse.accessToken)")
//        }
//    }
}
