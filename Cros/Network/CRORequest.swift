//
//  CRORequest.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation
import Alamofire

struct APIPath {
    static let uniqueId = "device/uniqueIdentification"
    static let login = "wallet/login/basic/login"
    static let register = "wallet/login/basic/regist"
    static let verifiedMessage = "base/message/createMessage"
    static let forgetPassword = "wallet/login/wallet/forgetPassword"
    static let walletList = "wallet/walletList"
    static let transaction = "asset/assets"
    static let myAccount = "asset/user/userAssetIndex"
    static let mineralAccount = "mining/user/mining/userCurrencyIndex"
    static let userInfo = "wallet/user/wallet/userInfo"
}

fileprivate let isOnLine = false
let baseURL = isOnLine ? "http://www.weibeichain.com/" : "http://120.27.234.14:8081/"
let h5BaseURL = "http://120.27.234.14:8081/wallet-web/#/"
//let h5BaseURL = "http://10.109.20.33:8080/#/"
typealias CROResponse = (_ errorCode: Int, _ data: Any?) -> Void
typealias CROResponseAndErrMsg = (_ errorCode: Int, _ data: Any?, _ errMsg: String) -> Void
let kNoNetworkError = "网络出现问题，请稍后重试"
let kNoUniqueIDError = "缺少设备唯一标识"

class CRORequest {
    static let shard = CRORequest()
    var privateKey: String?

    func start(_ path: String, method: HTTPMethod = .post, parameters: Parameters = [:], needPrivateKey: Bool = false, needAuthorization: Bool = false, encoding: ParameterEncoding = JSONEncoding.default, headers: HTTPHeaders = ["Content-Type": "application/json"], responseWithErrMsg: CROResponseAndErrMsg?) {
        var param = parameters
        if needPrivateKey {
            param["privateKeyStr"] = privateKey ?? ""
            param["privateKeyStr"] = "40e0e2c3-3467-4325-862f-45b4f23667181531451925929"
        }
        var allHeaders = headers
        if needAuthorization {
            allHeaders["authorization"] = UserInfo.shard.token
        }
        Alamofire.request(baseURL + path, method: method, parameters: param, encoding: encoding, headers: allHeaders).validate().responseJSON { (res) in
            guard let data = res.result.value as? [String: Any] else {
                responseWithErrMsg?(-1, nil, kNoNetworkError)
                return
            }
            switch res.result {
            case .success:
                guard let success = data["success"] as? Bool, success, let obj = data["obj"] else {
                    if let code = data["code"] as? String, code == "403" {
                        UserInfo.shard.clear()
                        NotificationCenter.default.post(name: kLogoutSucceedNotification, object: nil)
                        responseWithErrMsg?(-1, nil, "登录过期，请重新登录")
                        return
                    }
                    responseWithErrMsg?(-1, nil, data["msg"] as? String ?? kNoNetworkError)
                    return
                }
                responseWithErrMsg?(0, obj, "")
            case .failure:
                responseWithErrMsg?(-1, nil, data["msg"] as? String ?? kNoNetworkError)
            }
        }
    }
}
