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

fileprivate let isOnLine = true
fileprivate let baseURL = isOnLine ? "http://www.weibeichain.com/" : "http://120.27.234.14:8081/"
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
            param["privateKeyStr"] = "db6042b6-0709-4a81-9aa4-a44169b42ea61533002946382"
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
