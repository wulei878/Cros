//
//  ForgotPwdViewController.swift
//  Cros
//
//  Created by Owen on 2018/8/3.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class ForgotPwdViewController: UIViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "忘记密码"
        addViews()
        addBackBtn()
        showPwdBtn.addTarget(self, action: #selector(showOrHidePwd(_:)), for: .touchUpInside)
        showPwdConfirmBtn.addTarget(self, action: #selector(showOrHidePwd(_:)), for: .touchUpInside)
        pwdTextField.rightView = showPwdBtn
        pwdConfirmTextField.rightView = showPwdConfirmBtn
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        loginModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
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
        container.addSubview(pwdTextField)
        container.addSubview(msgCodeTextField)
        let verticalLine = UIView.verticalLine()
        container.addSubview(verticalLine)
        container.addSubview(msgCodeBtn)
        container.addSubview(pwdConfirmTextField)
        scrollView.addSubview(confirmBtn)
        let firstLine = UIView.bottomLine()
        let secondLine = UIView.bottomLine()
        let thirdLine = UIView.bottomLine()
        [firstLine, secondLine, thirdLine].forEach { (view) in
            container.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
            })
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
            make.height.equalTo(50)
        }
        firstLine.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom)
        }
        msgCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firstLine.snp.bottom)
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
        secondLine.snp.makeConstraints { (make) in
            make.top.equalTo(msgCodeTextField.snp.bottom)
        }
        pwdTextField.snp.makeConstraints { (make) in
            make.top.equalTo(secondLine.snp.bottom)
            make.left.right.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        thirdLine.snp.makeConstraints { (make) in
            make.top.equalTo(pwdTextField.snp.bottom)
        }
        pwdConfirmTextField.snp.makeConstraints { (make) in
            make.top.equalTo(thirdLine.snp.bottom)
            make.left.right.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
            make.bottom.equalTo(0)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(container.snp.bottom).offset(108)
            make.left.equalTo(38)
            make.right.equalTo(-38)
            make.height.equalTo(45)
            make.bottom.equalTo(-20)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - event response
    @objc func showOrHidePwd(_ button: UIButton) {
        let textField = button == showPwdBtn ? pwdTextField : pwdConfirmTextField
        textField.isSecureTextEntry = !textField.isSecureTextEntry
        button.setImage(textField.isSecureTextEntry ? #imageLiteral(resourceName: "hide_password") : #imageLiteral(resourceName: "show_password"), for: .normal)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        loginModel.getVerifiedMsg(mobile: phoneTextField.text ?? "", type: 2)
    }

    @objc func resetPassword() {
        let validation = InputValidation()
        if let result = validation.validatePhone(phoneTextField.text) {
            HUD.showText(result, in: view)
            return
        }
        if let result = validation.validateVerifyCode(msgCodeTextField.text) {
            HUD.showText(result, in: view)
            return
        }
        if let result = validation.validatePassword(pwdTextField.text) {
            HUD.showText(result, in: view)
            return
        }
        if let result = validation.validateConfirmPassword(pwdTextField.text, confirmPassword: pwdConfirmTextField.text) {
            HUD.showText(result, in: view)
            return
        }
        loginModel.resetPassword(phone: phoneTextField.text ?? "", password: pwdTextField.text ?? "", verificationCode: msgCodeTextField.text ?? "")
    }

    @objc func updateTime() {
        guard countDown > 0 else {
            timer?.invalidate()
            timer = nil
            return
        }
        countDown -= 1
    }

    // MARK: - getter and setter
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
        textField.placeholder = "新密码"
        textField.rightViewMode = .always
        return textField
    }()
    let pwdConfirmTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.customType()
        textField.clearButtonMode = .whileEditing
        textField.rightViewMode = .always
        textField.placeholder = "确认密码"
        return textField
    }()
    let msgCodeTextField: UITextField = {
        let textField = UITextField()
        textField.customType()
        textField.placeholder = "请输入短信验证码"
        return textField
    }()
    let msgCodeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("获取验证码", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x4a9eff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(getVerifyCode), for: .touchUpInside)
        return button
    }()
    let confirmBtn: UIButton = {
        let button = UIButton()
        button.customType("确定")
        button.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        return button
    }()
    let showPwdBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "hide_password"), for: .normal)
        button.size = CGSize(width: 44, height: 44)
        return button
    }()
    let showPwdConfirmBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "hide_password"), for: .normal)
        button.size = CGSize(width: 44, height: 44)
        return button
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
}

// MARK: - delegate
extension ForgotPwdViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        var textField: UITextField!
        var maxLength = 0
        if phoneTextField.isFirstResponder {
            textField = phoneTextField
            maxLength = phoneNumberMaxLength
        } else if pwdTextField.isFirstResponder {
            textField = pwdTextField
            maxLength = passwordMaxLength
        } else if pwdConfirmTextField.isFirstResponder {
            textField = pwdConfirmTextField
            maxLength = passwordMaxLength
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

extension ForgotPwdViewController: LoginModelDelegate {
    func getVerifiedMsgCompleted(_ errCode: Int, errMsg: String?) {
        guard errCode == 0 else {
            HUD.showText(errMsg ?? "", in: view)
            return
        }
    }
    func resetPwdCompleted(_ errCode: Int, errMsg: String?) {
        guard errCode == 0 else {
            HUD.showText(errMsg ?? "", in: view)
            return
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
