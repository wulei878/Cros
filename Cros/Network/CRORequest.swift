//
//  CRORequest.swift
//  Cros
//
//  Created by owen on 2018/8/1.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let isOnLine = true
fileprivate let baseURL = isOnLine ? "http://10.1.99.31:3000" : ""
typealias CROResponse = (_ errorCode: Int, _ data: Any?) -> Void

public class CRORequest {
    public static let shard = CRORequest()

    func start(_ path: String, method: HTTPMethod = .get, parameters: Parameters = [:], response: CROResponse?) {
        Alamofire.request(baseURL + path, method: method, parameters: parameters).validate().responseJSON { (res) in
            switch res.result {
            case .success:
                response?(0, res.result.value)
            case .failure:
                response?(-1, nil)
            }
        }
    }
}

