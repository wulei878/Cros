//
//  HomeCollectionViewCellModel.swift
//  Alamofire
//
//  Created by owen on 2018/7/16.
//

import UIKit

class HomeTransactionCellModel: NSObject {
    var title = "交易资产"
    var subTitle = "总资产"
    var accountNum = "0.00"
    var unitStr = "CNY"
    var walletName = "钱包名称"
    var walletCode = "7c4a8d09ca3762af61e59520943dc26494f8941b"
    var showMoreBtn = true
    var showQRCodeBtn = true
    var gradientColors = [UIColor(rgb: 0x599dfe).cgColor, UIColor(rgb: 0x656dff).cgColor]
    override init() {
        super.init()
    }

    init(dic: [String: Any]) {
        super.init()
    }
}
