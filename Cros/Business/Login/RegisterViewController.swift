//
//  RegisterViewController.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.customType()
        textField.placeholder = "请输入手机号"
        return textField
    }()
    let psdTextField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.customType()
        textField.placeholder = "请设置密码"
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
}
