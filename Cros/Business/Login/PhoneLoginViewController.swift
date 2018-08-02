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
class PhoneLoginViewController: UIViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addBarButtonItems()
        addViews()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func addBarButtonItems() {
        let registerBtn = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(gotoRegisterVC))
        registerBtn.tintColor = UIColor(rgb: 0x4a9eff)
        navigationItem.leftBarButtonItems = [registerBtn]
        let closeBtn = UIButton(type: .custom)
        closeBtn.setImage(#imageLiteral(resourceName: "close_icon"), for: .normal)
        closeBtn.size = CGSize(width: 44, height: 44)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: closeBtn)]
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        navigationController?.customNavStyle()
    }

    func addViews() {
        let container = UIView()
        view.addSubview(container)
        container.addSubview(titleLbl)
        container.addSubview(phoneTextField)
        container.addSubview(pwdTextField)
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
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top + 46)
            make.centerX.equalTo(container)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLbl.snp.bottom).offset(65)
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
    }

    func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
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
        navigationController?.pushViewController(VerifyPhoneViewController(), animated: true)
    }

    // MARK: - getter and setter
    let titleLbl: UILabel = {
        let titleLbl = UILabel()
        titleLbl.textColor = UIColor(rgb: 0x24323d)
        titleLbl.font = UIFont.systemFont(ofSize: 18)
        titleLbl.text = "欢迎来到微贝包包"
        return titleLbl
    }()
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
