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
        title = "注册账号"
        addViews()
    }

    func addViews() {
        view.addSubview(scrollView)
        view.backgroundColor = UIColor(rgb: 0xf5f8fa)
        let container = UIView()
        container.backgroundColor = .white
        scrollView.addSubview(container)
        scrollView.backgroundColor = .clear
        container.addSubview(phoneTextField)
        container.addSubview(psdTextField)
        container.addSubview(imageCodeTextField)
        container.addSubview(imageCodeView)
        container.addSubview(msgCodeTextField)
        let verticalLine = UIView.verticalLine()
        container.addSubview(verticalLine)
        container.addSubview(msgCodeBtn)
        container.addSubview(inviteCodeTextField)
        scrollView.addSubview(registerBtn)
        scrollView.addSubview(tipsLbl)
        let firstLine = UIView.bottomLine()
        let secondLine = UIView.bottomLine()
        let thirdLine = UIView.bottomLine()
        let forthLine = UIView.bottomLine()
        [firstLine, secondLine, thirdLine, forthLine].forEach { (view) in
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
        psdTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firstLine.snp.bottom)
            make.left.right.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        secondLine.snp.makeConstraints { (make) in
            make.top.equalTo(psdTextField.snp.bottom)
        }
        imageCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(secondLine.snp.bottom)
            make.left.equalTo(firstLine)
            make.height.equalTo(phoneTextField)
        }
        imageCodeView.snp.makeConstraints { (make) in
            make.left.equalTo(imageCodeTextField.snp.right)
            make.right.equalTo(firstLine)
            make.centerY.equalTo(imageCodeTextField)
        }
        thirdLine.snp.makeConstraints { (make) in
            make.top.equalTo(imageCodeTextField.snp.bottom)
        }
        msgCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(thirdLine.snp.bottom)
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
        }
        forthLine.snp.makeConstraints { (make) in
            make.top.equalTo(msgCodeTextField.snp.bottom)
        }
        inviteCodeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(forthLine.snp.bottom)
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

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
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
    let imageCodeView: GraphCodeView = {
        let view = GraphCodeView(frame: CGRect(x: 0, y: 0, width: 95, height: 32))
        view.codeStr = "a71b"
        return view
    }()
    let msgCodeBtn: UIButton = {
        let button = UIButton()
        button.setTitle("获取验证码", for: .normal)
        return button
    }()
    let registerBtn: UIButton = {
        let button = UIButton()
        button.customType("注册")
        return button
    }()
    let tipsLbl: UILabel = {
        let label = UILabel()
        let attrDic1: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10),
                                                      NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x212121)]
        let attrStr = NSMutableAttributedString(string: "注册表示您接受",
                                                attributes: attrDic1)
        let attrDic2: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10),
                       NSAttributedStringKey.foregroundColor: UIColor(rgb: 0x4a9eff),
                       NSAttributedStringKey.link: "https://www.baidu.com"]
        attrStr.append(NSAttributedString(string: "《服务协议》",
                                          attributes: attrDic2))
        attrStr.append(NSAttributedString(string: "和",
                                          attributes: attrDic1))
        attrStr.append(NSAttributedString(string: "《隐私政策》", attributes: attrDic2))
        label.attributedText = attrStr
        return label
    }()
}
