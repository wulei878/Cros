//
//  VerifyCodeViewController.swift
//  Cros
//
//  Created by Owen on 2018/8/3.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

fileprivate let verifyCodeViewWidth: CGFloat = 36
class VerifyCodeViewController: UIViewController {
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        subTitleLbl.text = "已发送验证码到\n\(phoneNum)"
        addBackBtn()
        addViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let inputTap = UITapGestureRecognizer(target: self, action: #selector(startInput))
        codeContainer.addGestureRecognizer(inputTap)
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
        scrollView.addSubview(subTitleLbl)
        scrollView.addSubview(codeTextField)
        scrollView.addSubview(codeContainer)
        scrollView.addSubview(resendBtn)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        titleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(46)
            make.left.right.width.equalTo(scrollView)
        }
        subTitleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(titleLbl.snp.bottom).offset(55)
            make.centerX.equalTo(scrollView)
        }
        codeContainer.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLbl.snp.bottom).offset(20)
            make.left.equalTo(42)
            make.right.equalTo(-42)
            make.height.equalTo(34)
        }
        codeTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(codeContainer)
        }
        resendBtn.snp.makeConstraints { (make) in
            make.top.equalTo(codeContainer.snp.bottom).offset(15)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(100)
            make.height.equalTo(44)
            make.bottom.equalTo(-20)
        }
        addMsgCodeViews()
    }

    func addMsgCodeViews() {
        codeContainer.layoutIfNeeded()
        let length = CGFloat(verifyCodeMaxLength)
        let space = (codeContainer.width - verifyCodeViewWidth * length) / (length - 1)
        var preView: UIView!
        for index in 0..<verifyCodeMaxLength {
            let view = VerifyCodeView(frame: .zero)
            codeContainer.addSubview(view)
            view.snp.makeConstraints { (make) in
                if index == 0 {
                    make.left.top.bottom.equalTo(0)
                } else if index == verifyCodeMaxLength - 1 {
                    make.right.equalTo(0)
                }
            }
            if index > 0 {
                view.snp.makeConstraints { (make) in
                    make.top.bottom.equalTo(0)
                    make.left.equalTo(preView.snp.right).offset(space)
                }
            }
            codeContainer.addSubview(view)
            preView = view
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - event response
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func startInput() {
        codeTextField.becomeFirstResponder()
    }

    // MARK: - getter and setter
    var phoneNum = ""

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
    let subTitleLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x24323d)
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    let codeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        return textField
    }()
    let resendBtn: UIButton = {
        let button = UIButton()
        button.setTitle("重新发送（60）", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x545d66), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    let codeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
}

// MARK: - delegate
extension VerifyCodeViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        let textField = codeTextField
        let maxLength = verifyCodeMaxLength
        if let text = textField.text {
            let range = text.startIndex..<text.index(text.startIndex, offsetBy: 6)
            let numStr = String(text[range])
            codeContainer.subviews.forEach { view in
                guard let v = view as? VerifyCodeView else {return}
                v.number = numStr
            }
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

class VerifyCodeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.width.equalTo(verifyCodeViewWidth)
            make.height.equalTo(1)
        }
        label.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var number = "" {
        didSet {
            label.text = number
        }
    }

    let label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x545d66)
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x24323d)
        return view
    }()
}
