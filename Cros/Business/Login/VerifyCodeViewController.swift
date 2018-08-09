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
        addBackBtn()
        addViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let inputTap = UITapGestureRecognizer(target: self, action: #selector(startInput))
        codeContainer.addGestureRecognizer(inputTap)
        loginModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSucceed), name: kLoginSucceedNotification, object: nil)
        timer = Timer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        if let timer = self.timer {
            countDown = 60
            RunLoop.main.add(timer, forMode: .defaultRunLoopMode)
            timer.fire()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        timer?.invalidate()
        timer = nil
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
            codeLabelViews.append(view)
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

    @objc func updateTime() {
        guard countDown > 0 else {
            timer?.invalidate()
            timer = nil
            return
        }
        countDown -= 1
    }

    @objc func resendVerifyCode() {
        loginModel.getVerifiedMsg(mobile: phoneNum, type: 3)
    }

    @objc func loginSucceed() {
        isLoginProcessing = false
        navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - getter and setter
    var timer: Timer?
    var countDown = 60 {
        didSet {
            let str = countDown == 0 ? "重新发送" : "重新发送（\(countDown)）"
            resendBtn.setTitle(str, for: .normal)
            resendBtn.isEnabled = countDown == 0
        }
    }
    var phoneNum = "" {
        didSet {
            var startIndex = phoneNum.startIndex
            var result = ""
            let num = String(phoneNum.reversed())
            while startIndex < num.endIndex {
                guard let nextIndex = num.index(startIndex, offsetBy: 4, limitedBy: num.endIndex) else {
                    result.append(String(num[startIndex..<num.endIndex]))
                    break
                }
                result.append(String(num[startIndex..<nextIndex]))
                result.append(" ")
                startIndex = nextIndex
            }
            result = String(result.reversed())
            subTitleLbl.text = "已发送验证码到\n"+result
        }
    }
    var codeLabelViews = [VerifyCodeView]()

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
        label.textAlignment = .center
        return label
    }()
    let codeTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        return textField
    }()
    let resendBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(rgb: 0x545d66), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.addTarget(self, action: #selector(resendVerifyCode), for: .touchUpInside)
        return button
    }()
    let codeContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let loginModel = LoginModel()
    var isLoginProcessing = false
}

// MARK: - delegate
extension VerifyCodeViewController: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        let textField = codeTextField
        let maxLength = verifyCodeMaxLength
        if let text = textField.text {
            for (index, view) in codeLabelViews.enumerated() {
                if index >= text.count {
                    view.number = ""
                } else {
                    let i = text.index(text.startIndex, offsetBy: index)
                    view.number = String(text[i])
                }
            }
            if text.count >= 6, !isLoginProcessing {
                isLoginProcessing = true
                loginModel.login(password: "", phone: phoneNum, verificationCode: text)
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

extension VerifyCodeViewController: LoginModelDelegate {
    func getVerifiedMsgCompleted(_ errCode: Int, errMsg: String?) {
        guard errCode == 0 else {
            HUD.showText(errMsg ?? "", in: view)
            return
        }
    }

    func loginFail(_ errCode: Int, errMsg: String?) {
        isLoginProcessing = false
        guard errCode == 0 else {
            HUD.showText(errMsg ?? "", in: view)
            return
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
        label.textAlignment = .center
        return label
    }()
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0x24323d)
        return view
    }()
}
