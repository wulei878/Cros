//
//  HomeListTableCellModel.swift
//  Cros
//
//  Created by owen on 2018/8/6.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation

class HomeListTableCellModel {
    var coinImageURLStr = ""
    var coinTitle = "CROS"
    var amount = "0.0000"
    var marketValue = "≈0.00 CNY"
    var unitPrice = "≈0.00 CNY"

    class func transaction(_ dict:[String:Any]?) -> HomeListTableCellModel {
        let model = HomeListTableCellModel()
        model.title = "交易资产"
        model.subTitle = "总资产"
        model.unitStr = "CNY"
        model.showMoreBtn = true
        model.showQRCodeBtn = true
        model.gradientColors = [UIColor(rgb: 0x599dfe).cgColor, UIColor(rgb: 0x656dff).cgColor]
        model.accountNum = dict?["totalValue"] as? String ?? "0.00"
        model.walletName = dict?["walletName"] as? String ?? "钱包名称"
        model.walletCode = dict?["walletAddress"] as? String ?? "7c4a8d09ca3762af61e59520943dc26494f8941b"
        model.focusCoins = dict?["focusCoin"] as? [[String:Any]] ?? [[String:Any]]()
        return model
    }
}

