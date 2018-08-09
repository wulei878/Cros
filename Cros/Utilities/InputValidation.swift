//
//  InputValidation.swift
//  Cros
//
//  Created by owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation
import UIKit

struct RegexHelper {
    let regex: NSRegularExpression

    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern,
                                        options: [])
    }

    func match(input: String) -> Bool {
        let matches = regex.matches(in: input,
                                            options: [],
                                            range: NSRange(location: 0, length: input.utf16.count))
        return matches.count > 0
    }
}

struct InputValidation {
    let kPhoneNumberError = "手机号码输入有误"
    let kPasswordError = "密码输入有误"
    let kConfirmPasswordError = "两次密码输入不一致"
    let kNickNameError = "昵称输入有误"
    let kVerifyCodeError = "验证码输入有误"
    let kVerifyImageCodeError = "图形验证码输入有误"
    func validatePhone(_ phone: String?) -> String? {
        guard let input = phone else { return kPhoneNumberError }
        do {
            let pattern = "^1[0-9]{10}$"
            let matcher = try RegexHelper(pattern)
            guard matcher.match(input: input) else { return kPhoneNumberError }
        } catch {
            print(error)
        }
        return nil
    }
    func validatePassword(_ password: String?) -> String? {
        guard let input = password else { return kPasswordError }
        do {
            let pattern = ".{6,20}$"
            let matcher = try RegexHelper(pattern)
            guard matcher.match(input: input) else { return kPasswordError }
        } catch {
            print(error)
        }
        return nil
    }
    func validateConfirmPassword(_ password: String?, confirmPassword: String?) -> String? {
        if let password = password, let confirmPassword = confirmPassword, password == confirmPassword {
            return nil
        }
        return kConfirmPasswordError
    }
    func validateNickName(_ nickName: String?) -> String? {
        guard let input = nickName else { return kNickNameError }
        do {
            let pattern = "^.{1,10}$"
            let matcher = try RegexHelper(pattern)
            guard matcher.match(input: input) else { return kNickNameError }
        } catch {
            print(error)
        }
        return nil
    }
    func validateVerifyCode(_ verifyCode: String?) -> String? {
        guard let input = verifyCode else { return kVerifyCodeError }
        do {
            let pattern = "^[0-9]{6}$"
            let matcher = try RegexHelper(pattern)
            guard matcher.match(input: input) else { return kVerifyCodeError }
        } catch {
            print(error)
        }
        return nil
    }
    func validateVerifyImageCode(_ verifyCode: String?, originCode: String) -> String? {
        if let input = verifyCode, input == originCode {
            return nil
        }
        return kVerifyImageCodeError
    }
    func validateRegisterInfo(phone: String?, name: String?, password: String?, confirmPwd: String?, imageCode: String?, originImageCode: String, msgCode: String?, invitationCode: String?) -> String? {
        if let result = validatePhone(phone) {
            return result
        }
        if let result = validateNickName(name) {
            return result
        }
        if let result = validatePassword(password) {
            return result
        }
        if let result = validateConfirmPassword(password, confirmPassword: confirmPwd) {
            return result
        }
        if let result = validateVerifyImageCode(imageCode, originCode: originImageCode) {
            return result
        }
        if let result = validateVerifyCode(msgCode) {
            return result
        }
        return nil
    }
}
