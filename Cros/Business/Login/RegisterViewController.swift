//
//  RegisterViewController.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册账号"
        addViews()
        addBackBtn()
        dismissKeyboardTap.isEnabled = false
        view.addGestureRecognizer(dismissKeyboardTap)
        imageCodeView.delegate = self
        imageCodeView.codeStr = randomImageCode(count: imageCodeMaxLength)
        loginModel.delegate = self
        tipsLbl.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: Notification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: Notification.Name.UIKeyboardDidHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
        timer = nil
    }

    func addViews() {
        view.addSubview(scrollView)
        view.backgroundColor = UIColor(rgb: 0xf5f8fa)
        let container = UIView()
        container.backgroundColor = .white
        scrollView.addSubview(container)
        scrollView.backgroundColor = .clear
        container.addSubview(phoneTextField)
        container.addSubview(nickNameTextField)
        container.addSubview(pwdTextField)
        container.addSubview(pwdConfirmTextField)
        container.addSubview(imageCodeTextField)
        container.addSubview(imageCodeView)
        container.addSubview(msgCodeTextField)
        let verticalLine = UIView.verticalLine()
        container.addSubview(verticalLine)
        container.addSubview(msgCodeBtn)
        container.addSubview(inviteCodeTextField)
        scrollView.addSubview(registerBtn)
        scrollView.addSubview(tipsLbl)
        var firstLine: UIView!
        for index in 1...6 {
            let line = UIView.bottomLine()
            container.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(50 * index)
            }
            if index == 1 {
                firstLine = line
            }
        }
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        container.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.right.width.equalTo(scrollView)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(firstLine)
            make.height.equalTo(49)
        }
        nickNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(1)
            make.left.right.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        pwdTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(1)
            make.left.right.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        pwdConfirmTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pwdTextField.snp.bottom).offset(1)
            make.left.right.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        imageCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(pwdConfirmTextField.snp.bottom).offset(1)
            make.left.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        imageCodeView.snp.makeConstraints { (make) in
            make.left.equalTo(imageCodeTextField.snp.right)
            make.right.equalTo(firstLine)
            make.centerY.equalTo(imageCodeTextField)
            make.width.equalTo(95)
            make.height.equalTo(32)
        }
        msgCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(imageCodeTextField.snp.bottom).offset(1)
            make.left.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        verticalLine.snp.makeConstraints { (make) in
            make.left.equalTo(msgCodeTextField.snp.right).offset(5)
            make.height.equalTo(21)
            make.centerY.equalTo(msgCodeTextField)
        }
        msgCodeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(verticalLine.snp.right).offset(5)
            make.centerY.equalTo(msgCodeTextField)
            make.right.equalTo(firstLine)
            make.height.equalTo(44)
            make.width.equalTo(80)
        }
        inviteCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(msgCodeTextField.snp.bottom).offset(1)
            make.left.right.equalTo(firstLine)
            make.bottom.equalTo(0)
            make.height.equalTo(phoneTextField)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(container.snp.bottom).offset(60)
            make.left.equalTo(38)
            make.right.equalTo(-38)
            make.height.equalTo(45)
        }
        tipsLbl.snp.makeConstraints { (make) in
            make.top.equalTo(registerBtn.snp.bottom).offset(15)
            make.centerX.equalTo(scrollView)
            make.bottom.equalTo(-20)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardDidShow() {
        dismissKeyboardTap.isEnabled = true
    }

    @objc func keyboardDidHide() {
        dismissKeyboardTap.isEnabled = false
    }
    // MARK: - event response
    @objc func getVerifyCode() {
        let validate = InputValidation()
        if let result = validate.validatePhone(phoneTextField.text) {
            HUD.showText(result, in: view)
            return
        }
        if let result = validate.validateVerifyImageCode(imageCodeTextField.text, originCode: imageCodeView.codeStr) {
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

    @objc func register() {
        let validation = InputValidation()
        if let result = validation.validateRegisterInfo(phone: phoneTextField.text, name: nickNameTextField.text, password: pwdTextField.text, confirmPwd: pwdConfirmTextField.text, imageCode: imageCodeTextField.text, originImageCode: imageCodeView.codeStr, msgCode: msgCodeTextField.text, invitationCode: inviteCodeTextField.text) {
            HUD.showText(result, in: view)
            return
        }
        loginModel.register(phone: phoneTextField.text ?? "", password: pwdTextField.text ?? "", verificationCode: msgCodeTextField.text ?? "")
    }

    @objc func updateTime() {
        guard countDown > 0 else {
            timer?.invalidate()
            timer = nil
            return
        }
        countDown -= 1
    }

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.customType()
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "请输入手机号"
        return textField
    }()
    let pwdTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.customType()
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "请输入密码"
        return textField
    }()
    let pwdConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.customType()
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "请输入确认密码"
        return textField
    }()
    let imageCodeTextField: UITextField = {
        let textField = UITextField()
        textField.customType()
        textField.placeholder = "请输入图形验证码"
        return textField
    }()
    let msgCodeTextField: UITextField = {
        let textField = UITextField()
        textField.customType()
        textField.placeholder = "请输入短信验证码"
        return textField
    }()
    let inviteCodeTextField: UITextField = {
        let textField = UITextField()
        textField.customType()
        textField.placeholder = "请输入邀请码（选填）"
        return textField
    }()
    let imageCodeView: GraphCodeView = {
        let view = GraphCodeView(frame: CGRect(x: 0, y: 0, width: 95, height: 32))
        return view
    }()
    let msgCodeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x4a9eff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(getVerifyCode), for: .touchUpInside)
        return button
    }()
    let registerBtn: UIButton = {
        let button = UIButton()
        button.customType("注册")
        button.addTarget(self, action: #selector(register), for: .touchUpInside)
        return button
    }()
    let tipsLbl: TTTAttributedLabel = {
        let label = TTTAttributedLabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(rgb: 0x212121)
        label.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
        label.text = "注册表示您接受《服务协议》和《隐私政策》"
        if let range = (label.text as NSString?)?.range(of: "《服务协议》") {
            label.addLink(to: URL(string: h5BaseURL + "userInfo/agreement"), with: range)
        }
        if let range = (label.text as NSString?)?.range(of: "《隐私政策》") {
            label.addLink(to: URL(string: h5BaseURL + "userInfo/agreement"), with: range)
        }
//        let attrDic2: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10),
//                                                      NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x4a9eff)]
//        label.activeLinkAttributes = attrDic2
        return label
    }()
    let nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入昵称"
        textField.clearButtonMode = .whileEditing
        textField.customType()
        return textField
    }()
    let loginModel = LoginModel()
    var timer: Timer?
    var countDown = 60 {
        didSet {
            let str = countDown == 0 ? "获取验证码" : "\(countDown)秒"
            msgCodeBtn.setTitle(str, for: .normal)
            msgCodeBtn.isEnabled = countDown == 0
        }
    }
    let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
}

// MARK: - delegate
extension RegisterViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        var textField: UITextField!
        var maxLength = 0
        if phoneTextField.isFirstResponder {
            textField = phoneTextField
            maxLength = phoneNumberMaxLength
        } else if pwdTextField.isFirstResponder {
            textField = pwdTextField
            maxLength = passwordMaxLength
        } else if imageCodeTextField.isFirstResponder {
            textField = imageCodeTextField
            maxLength = imageCodeMaxLength
        } else if pwdConfirmTextField.isFirstResponder {
            textField = pwdConfirmTextField
            maxLength = passwordMaxLength
        } else if nickNameTextField.isFirstResponder {
            textField = nickNameTextField
            maxLength = 10
        } else {
            return
        }
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

extension RegisterViewController: GraphCodeViewDelegate {
    func didTap(_ graphCodeView: GraphCodeView!) {
        graphCodeView.codeStr = randomImageCode(count: imageCodeMaxLength)
    }

    func randomImageCode(count: Int) -> String {
        var str = ""
        for _ in 0..<count {
            let num = arc4random() % 36
            if num < 10 {
                let figure = arc4random() % 10
                str.append("\(figure)")
            } else {
                let figure = arc4random() % 26 + 97
                guard let unicode = UnicodeScalar(figure) else { break }
                str.append(String(unicode))
            }
        }
        return str
    }
}

extension RegisterViewController: LoginModelDelegate {
    func getVerifiedMsgCompleted(_ errCode: Int, errMsg: String?) {
        guard errCode == 0 else {
            HUD.showText(errMsg ?? "", in: view)
            return
        }
    }
    func registerCompleted(_ errCode: Int, errMsg: String?) {
        guard errCode == 0 else {
            HUD.showText(errMsg ?? "", in: view)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
}

extension RegisterViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        WebViewController.shard.url = url.absoluteString
        WebViewController.shard.showNavi = true
        navigationController?.pushViewController(WebViewController.shard, animated: true)
    }
}
