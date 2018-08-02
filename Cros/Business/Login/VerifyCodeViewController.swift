//
//  VerifyCodeViewController.swift
//  Cros
//
//  Created by Owen on 2018/8/3.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class VerifyCodeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        subTitleLbl.text = "已发送验证码到/n\(phoneNum)"
        addBackBtn()
        addViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func addViews() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = .white
        scrollView.addSubview(titleLbl)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(confirmBtn)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(46)
            make.left.right.width.equalTo(scrollView)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom).offset(65)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(50)
        }
        let bottomLine = UIView.bottomLine()
        scrollView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom)
            make.left.right.equalTo(phoneTextField)
        }
        confirmBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLine.snp.bottom).offset(44)
            make.left.equalTo(38)
            make.right.equalTo(-38)
            make.height.equalTo(45)
            make.bottom.equalTo(-20)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var phoneNum = 0
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x24323d)
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "验证手机号码"
        label.textAlignment = .center
        return label
    }()
    let subTitleLbl:UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x24323d)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.customType()
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "请输入手机号注册或登录"
        return textField
    }()
    let confirmBtn: UIButton = {
        let button = UIButton()
        button.customType("下一步")
        return button
    }()

}

// MARK: - delegate
extension VerifyCodeViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        let textField = phoneTextField
        let maxLength = phoneNumberMaxLength
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
