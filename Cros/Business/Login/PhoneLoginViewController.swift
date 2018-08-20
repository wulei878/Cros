//
//  PhoneLoginViewController.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

let passwordMaxLength = 20
let phoneNumberMaxLength = 11
let imageCodeMaxLength = 4
let verifyCodeMaxLength = 6
class PhoneLoginViewController: UIViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.customNavStyle()
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

    func addViews() {
        let container = UIView()
        view.addSubview(container)
        container.addSubview(topMaskView)
        container.addSubview(backBtn)
        container.addSubview(appIconImage)
        container.addSubview(phoneTextField)
        container.addSubview(pwdTextField)
        container.addSubview(registerBtn)
        container.addSubview(forgetPwdBtn)
        container.addSubview(loginBtn)
        container.addSubview(codeLoginBtn)
        let firstLine = UIView.bottomLine()
        let secondLine = UIView.bottomLine()
        container.addSubview(firstLine)
        container.addSubview(secondLine)
        pwdTextField.rightView = showPwdBtn
        showPwdBtn.addTarget(self, action: #selector(showOrHidePwd), for: .touchUpInside)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        topMaskView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(235 + safeAreaInsets.top)
        }
        backBtn.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top == 0 ? 15 : safeAreaInsets.top)
            make.left.equalTo(5)
            make.width.height.equalTo(44)
        }
        appIconImage.snp.makeConstraints { (make) in
            make.bottom.equalTo(topMaskView.snp.bottom).offset(-53)
            make.width.height.equalTo(90)
            make.centerX.equalTo(container)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(topMaskView.snp.bottom).offset(36)
            make.height.equalTo(50)
        }
        firstLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(phoneTextField.snp.bottom)
        }
        pwdTextField.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(phoneTextField)
            make.top.equalTo(firstLine.snp.bottom)
        }
        secondLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(phoneTextField)
            make.top.equalTo(pwdTextField.snp.bottom)
        }
        forgetPwdBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secondLine.snp.bottom).offset(5)
            make.right.equalTo(phoneTextField)
            make.width.equalTo(75)
            make.height.equalTo(44)
        }
        registerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(phoneTextField).offset(-15)
            make.centerY.size.equalTo(forgetPwdBtn)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(secondLine.snp.bottom).offset(70)
            make.left.equalTo(38)
            make.right.equalTo(-38)
            make.height.equalTo(45)
        }
        codeLoginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(loginBtn.snp.bottom).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(44)
            make.centerX.equalTo(container)
        }
        phoneTextField.delegate = self
        pwdTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        forgetPwdBtn.addTarget(self, action: #selector(gotoForgotPwdVC), for: .touchUpInside)
        codeLoginBtn.addTarget(self, action: #selector(gotoVerifyPhoneVC), for: .touchUpInside)
        registerBtn.addTarget(self, action: #selector(gotoRegisterVC), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
    }

    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSucceed), name: kLoginSucceedNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - event response
    @objc func gotoRegisterVC() {
        navigationController?.pushViewController(RegisterViewController(), animated: true)
    }

    @objc func closeAction() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func showOrHidePwd() {
        pwdTextField.isSecureTextEntry = !pwdTextField.isSecureTextEntry
        showPwdBtn.setImage(pwdTextField.isSecureTextEntry ? #imageLiteral(resourceName: "hide_password") : #imageLiteral(resourceName: "show_password"), for: .normal)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func gotoForgotPwdVC() {
        navigationController?.pushViewController(ForgotPwdViewController(), animated: true)
    }

    @objc func gotoVerifyPhoneVC() {
        navigationController?.pushViewController(QuickLoginViewController(), animated: true)
    }

    @objc func popBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func loginAction() {
        let validation = InputValidation()
        if let msg = validation.validatePhone(phoneTextField.text) {
            HUD.showText(msg, in: view)
            return
        }
        if let msg = validation.validatePassword(pwdTextField.text) {
            HUD.showText(msg, in: view)
            return
        }
        loginModel.login(password: pwdTextField.text ?? "", phone: phoneTextField.text ?? "", verificationCode: "")
        loginModel.delegate = self
    }

    // MARK: - getter and setter
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.customType()
        textField.placeholder = "请输入手机号"
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    let pwdTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.customType()
        textField.rightViewMode = .always
        textField.placeholder = "请输入登录密码"
        return textField
    }()
    let showPwdBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "hide_password"), for: .normal)
        button.size = CGSize(width: 44, height: 44)
        return button
    }()
    let forgetPwdBtn: UIButton = {
        let button = UIButton()
        button.setTitle("忘记密码？", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x4a9eff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    let loginBtn: UIButton = {
        let button = UIButton()
        button.customType("登录")
        return button
    }()
    let codeLoginBtn: UIButton = {
        let button = UIButton()
        button.setTitle("验证码快捷登录", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x999999), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    let topMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x4a9eff)
        return view
    }()
    let appIconImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let registerBtn: UIButton = {
        let button = UIButton()
        button.setTitle("注册", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x4a9eff), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    let backBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "back_white"), for: .normal)
        return button
    }()
    let loginModel = LoginModel()
}

// MARK: - delegate
extension PhoneLoginViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        let textField = pwdTextField.isFirstResponder ? pwdTextField : phoneTextField
        let maxLength = pwdTextField.isFirstResponder ? passwordMaxLength : phoneNumberMaxLength
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

extension PhoneLoginViewController: LoginModelDelegate {
    func loginFail(_ errCode: Int, errMsg: String?) {
        HUD.showText(errMsg ?? kNoNetworkError, in: view)
    }

    @objc func loginSucceed() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

extension UITextField {
    func customType() {
        textColor = UIColor(rgb: 0x24323d)
        font = UIFont.systemFont(ofSize: 15)
        height = 50
    }
}

extension UIView {
    class func bottomLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(rgb: 0xf2f2f2)
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
        }
        return line
    }
    class func verticalLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(rgb: 0xf2f2f2)
        line.snp.makeConstraints { (make) in
            make.width.equalTo(1)
        }
        return line
    }
}

extension PhoneLoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == navigationController?.interactivePopGestureRecognizer,
            let count = navigationController?.viewControllers.count,
            count > 1 else { return false }
        return true
    }
}

extension UINavigationController {
    func customNavStyle() {
        navigationBar.barTintColor = .white
        navigationBar.setBackgroundImage(UIImage(color: .white), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()
    }
}

extension UIButton {
    func customType(_ title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        setBackgroundImage(UIImage(color: UIColor(rgb: 0x4a9eff)), for: .normal)
        layer.cornerRadius = 4
        clipsToBounds = true
        height = 45
    }
}
