//
//  QuickLoginViewController.swift
//  Cros
//
//  Created by owen on 2018/8/20.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class QuickLoginViewController: UIViewController {
    // MARK: - getter and setter
    let headerView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "quick_login_bg"))
        return imageView
    }()
    let tipLbl: UILabel = {
        let label = UILabel()
        label.text = "输入验证码快捷登录或使用密码登录"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(rgb: 0xc6cacd)
        return label
    }()
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.customType()
        textField.placeholder = "请输入您的手机号"
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    let msgCodeTextField: UITextField = {
        let textField = UITextField()
        textField.customType()
        textField.placeholder = "请输入验证码"
        return textField
    }()
    let msgCodeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("获取验证码", for: .normal)
        button.setBackgroundColor(UIColor(rgb: 0x4a9eff), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(getVerifyCode), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 2
        return button
    }()
    let loginBtn: UIButton = {
        let button = UIButton()
        button.customType("登录")
        return button
    }()
    let pwdLoginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("密码登录", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x4a9eff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    let backBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "back_white"), for: .normal)
        return button
    }()
    let appIconImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let phonePrefixLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x76808e)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "+86"
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    let loginModel = LoginModel()
    var timer: Timer?
    var countDown = 60 {
        didSet {
            let str = countDown == 0 ? "发送验证码" : "\(countDown)秒"
            msgCodeBtn.setTitle(str, for: .normal)
            msgCodeBtn.isEnabled = countDown == 0
        }
    }
    let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(dismissKeyboardTap)
        addViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotifications()
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidChange, object: nil)
        UIApplication.shared.statusBarStyle = .default
        navigationController?.isNavigationBarHidden = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSucceed), name: kLoginSucceedNotification, object: nil)
    }

    func addViews() {
        let container = UIView()
        view.addSubview(container)
        container.addSubview(headerView)
        container.addSubview(backBtn)
        container.addSubview(appIconImage)
        container.addSubview(tipLbl)
        container.addSubview(phoneTextField)
        container.addSubview(phonePrefixLbl)
        container.addSubview(msgCodeTextField)
        container.addSubview(msgCodeBtn)
        container.addSubview(loginBtn)
        container.addSubview(pwdLoginBtn)
        let firstLine = UIView.bottomLine()
        let secondLine = UIView.bottomLine()
        container.addSubview(firstLine)
        container.addSubview(secondLine)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(188 + safeAreaInsets.top)
        }
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top == 0 ? 15 : safeAreaInsets.top)
            make.left.equalTo(5)
            make.width.height.equalTo(44)
        }
        appIconImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerView.snp.bottom).offset(-65)
            make.width.height.equalTo(54)
            make.centerX.equalToSuperview()
        }
        tipLbl.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(47)
            make.centerX.equalToSuperview()
        }
        firstLine.snp.makeConstraints { (make) in
            make.left.equalTo(45)
            make.right.equalTo(-45)
            make.top.equalTo(tipLbl.snp.bottom).offset(79)
        }
        phonePrefixLbl.snp.makeConstraints { (make) in
            make.left.equalTo(firstLine)
        }
        msgCodeBtn.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(25)
            make.right.equalTo(firstLine)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(phonePrefixLbl.snp.right).offset(10)
            make.right.equalTo(msgCodeBtn.snp.left).offset(-10)
            make.height.equalTo(50)
            make.bottom.equalTo(firstLine.snp.top)
        }
        phonePrefixLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneTextField)
        }
        msgCodeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneTextField)
        }
        secondLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(firstLine)
            make.top.equalTo(firstLine.snp.bottom).offset(60)
        }
        msgCodeTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneTextField)
            make.bottom.equalTo(secondLine.snp.top)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secondLine.snp.bottom).offset(70)
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        pwdLoginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(44)
            make.centerX.equalTo(container)
        }
        loginBtn.layer.cornerRadius = 20
        phoneTextField.delegate = self
        msgCodeTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        pwdLoginBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func popBack() {
        navigationController?.popViewController(animated: true)
    }
    @objc func loginAction() {
        let validation = InputValidation()
        if let msg = validation.validatePhone(phoneTextField.text) {
            HUD.showText(msg, in: view)
            return
        }
        if let msg = validation.validateVerifyCode(msgCodeTextField.text) {
            HUD.showText(msg, in: view)
            return
        }
        loginModel.login(password: "", phone: phoneTextField.text ?? "", verificationCode: msgCodeTextField.text ?? "")
        loginModel.delegate = self
    }

    @objc func getVerifyCode() {
        let validate = InputValidation()
        if let result = validate.validatePhone(phoneTextField.text) {
            HUD.showText(result, in: view)
            return
        }
        timer = Timer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        if let timer = self.timer {
            countDown = 60
            RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
            timer.fire()
        }
        loginModel.getVerifiedMsg(mobile: phoneTextField.text ?? "", type: 1)
    }

    @objc func updateTime() {
        guard countDown > 0 else {
            timer?.invalidate()
            timer = nil
            return
        }
        countDown -= 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK: - delegate
extension QuickLoginViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        let textField = phoneTextField.isFirstResponder ? phoneTextField : msgCodeTextField
        let maxLength = phoneTextField.isFirstResponder ? phoneNumberMaxLength : verifyCodeMaxLength
        let lang = UITextInputMode().primaryLanguage
        if lang == "zh-Hans" {
            guard let selectedRange = textField.markedTextRange,
                let _ = textField.position(from: selectedRange.start, offset: 0),
                let text = textField.text,
                text.count >= maxLength else { return }
            let range = text.startIndex..<text.index(text.startIndex, offsetBy: maxLength)
            textField.text = String(text[range])
        } else {
            guard let text = textField.text, text.count >= maxLength else { return }
            let range = text.startIndex..<text.index(text.startIndex, offsetBy: maxLength)
            textField.text = String(text[range])
        }
    }
}

extension QuickLoginViewController: LoginModelDelegate {
    func loginFail(_ errCode: Int, errMsg: String?) {
        HUD.showText(errMsg ?? kNoNetworkError, in: view)
    }

    @objc func loginSucceed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
