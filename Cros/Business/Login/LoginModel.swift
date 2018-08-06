//
//  LoginModel.swift
//  Cros
//
//  Created by owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation

@objc protocol LoginModelDelegate: class {
    @objc optional func loginCompleted(_ errorCode: Int, errorMessage: String?)
    @objc optional func getVerifiedMsgCompleted(_ errCode: Int, errMsg: String?)
    @objc optional func resetPwdCompleted(_ errCode: Int, errMsg: String?)
    @objc optional func registerCompleted(_ errCode: Int, errMsg: String?)
    @objc optional func getUniqueIdCompleted(_ errorCode: Int, _ errorMsg: String)
}

struct UserInfo {
    var id = ""
    var nickname = ""
    var token = ""
    var invitationCodeMy = ""
    var computePower = 0
    var authenticationStatus = false

    func isLogin() -> Bool {
        return token.count > 0
    }
    static var shard = UserInfo()
}

class LoginModel {
    weak var delegate: LoginModelDelegate?

    /// 登录接口
    ///
    /// - Parameters:
    ///   - password: 密码
    ///   - phone: 手机号
    ///   - tag: 默认1102
    ///   - verificationCode: 验证码
    func login(password: String, phone: String, verificationCode: String, tag: String="1102") {
        let param = ["password": password,
                     "phone": phone,
                     "tag": tag,
                     "verificationCode": verificationCode]
        CRORequest.shard.start(APIPath.login, parameters: param) { [weak self](errCode, data, msg) in
            guard errCode == 0, let obj = data as? [String: Any] else {
                self?.delegate?.loginCompleted?(-1, errorMessage: msg)
                return
            }
            UserInfo.shard.id = obj["id"] as? String ?? ""
            UserInfo.shard.nickname = obj["nickname"] as? String ?? ""
            UserInfo.shard.token = obj["token"] as? String ?? ""
            UserInfo.shard.invitationCodeMy = obj["invitationCodeMy"] as? String ?? ""
            UserInfo.shard.computePower = obj["computePower"] as? Int ?? 0
            UserInfo.shard.authenticationStatus = obj["authenticationStatus"] as? Bool ?? false
            self?.delegate?.loginCompleted?(0, errorMessage: nil)
        }
    }

    /// 获取验证码
    ///
    /// - Parameters:
    ///   - mobile: 手机号
    ///   - type: 快捷登录-3;忘记密码-2;
    func getVerifiedMsg(mobile: String, type: Int) {
        let param: [String: Any] = ["mobile": mobile, "type": type]
        CRORequest.shard.start(APIPath.verifiedMessage, method: .get, parameters: param) { [weak self](errCode, _, msg) in
            guard errCode == 0 else {
                self?.delegate?.getVerifiedMsgCompleted?(-1, errMsg: msg)
                return
            }
            self?.delegate?.getVerifiedMsgCompleted?(0, errMsg: nil)
        }
    }

    func resetPassword(phone: String, password: String, verificationCode: String, type: String="", nickname: String="", invitationCodeOthers: String="") {
        let param: [String: Any] = ["phone": phone,
                                  "password": password,
                                  "verificationCode": verificationCode,
                                  "type": type,
                                  "nickname": nickname,
                                  "invitationCodeOthers": invitationCodeOthers]
        CRORequest.shard.start(APIPath.forgetPassword, parameters: param) { [weak self](errCode, _, msg) in
            guard errCode == 0 else {
                self?.delegate?.resetPwdCompleted?(-1, errMsg: msg)
                return
            }
            self?.delegate?.resetPwdCompleted?(0, errMsg: nil)
        }
    }

    func register(phone: String, password: String, verificationCode: String, type: String="", nickname: String="", invitationCodeOthers: String="") {
        let param: [String: Any] = ["phone": phone,
                                  "password": password,
                                  "verificationCode": verificationCode,
                                  "type": type,
                                  "nickname": nickname,
                                  "invitationCodeOthers": invitationCodeOthers]
        CRORequest.shard.start(APIPath.register, parameters: param) { [weak self](errCode, _, msg) in
            guard errCode == 0 else {
                self?.delegate?.registerCompleted?(-1, errMsg: msg)
                return
            }
            self?.delegate?.registerCompleted?(0, errMsg: nil)
        }
    }

    func checkUniqueId() {
        let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: KeychainConfiguration.account, accessGroup: KeychainConfiguration.accessGroup)
        do {
            CRORequest.shard.privateKey = try passwordItem.readPassword()
            delegate?.getUniqueIdCompleted?(0, "")
            return
        } catch {
            print(error)
            if let uniqueID = UserDefaults.standard.string(forKey: KeychainConfiguration.accessGroup ?? "UniqueId") {
                CRORequest.shard.privateKey = uniqueID
                delegate?.getUniqueIdCompleted?(0, "")
            } else {
                getUniqueId()
            }
        }
    }
    func getUniqueId() {
        CRORequest.shard.start(APIPath.uniqueId) { [weak self](errorCode, data, msg) in
            guard errorCode == 0, let uniqueID = data as? String else {
                self?.delegate?.getUniqueIdCompleted?(-1, msg)
                return
            }
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: KeychainConfiguration.account, accessGroup: KeychainConfiguration.accessGroup)
            do {
                try passwordItem.savePassword(uniqueID)
                CRORequest.shard.privateKey = uniqueID
            } catch {
                print(error)
                UserDefaults.standard.set(uniqueID, forKey: KeychainConfiguration.accessGroup ?? "UniqueId")
                UserDefaults.standard.synchronize()
//                self?.delegate?.getUniqueIdCompleted?(-1, "无法保存设备标识")
            }
            self?.delegate?.getUniqueIdCompleted?(0, "")
        }
    }
}