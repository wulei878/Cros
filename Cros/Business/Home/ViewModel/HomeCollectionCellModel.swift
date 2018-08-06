//
//  HomeCollectionViewCellModel.swift
//  Alamofire
//
//  Created by owen on 2018/7/16.
//

import UIKit

class HomeCollectionCellModel {
    var title = "交易资产"
    var subTitle = "总资产"
    var accountNum = "0.00"
    var unitStr = "CNY"
    var walletName = "钱包名称"
    var walletCode = "7c4a8d09ca3762af61e59520943dc26494f8941b"
    var showMoreBtn = true
    var showQRCodeBtn = true
    var gradientColors = [UIColor(rgb: 0x599dfe).cgColor, UIColor(rgb: 0x656dff).cgColor]
    var focusCoins = [[String: Any]]()

    class func transaction(_ dict: [String: Any]?) -> HomeCollectionCellModel {
        let model = HomeCollectionCellModel()
        model.title = "交易资产"
        model.subTitle = "总资产"
        model.unitStr = "CNY"
        model.showMoreBtn = true
        model.showQRCodeBtn = true
        model.gradientColors = [UIColor(rgb: 0x599dfe).cgColor, UIColor(rgb: 0x656dff).cgColor]
        model.accountNum = dict?["totalValue"] as? String ?? "0.00"
        model.walletName = dict?["walletName"] as? String ?? "钱包名称"
        model.walletCode = dict?["walletAddress"] as? String ?? "7c4a8d09ca3762af61e59520943dc26494f8941b"
        model.focusCoins = dict?["focusCoin"] as? [[String: Any]] ?? [[String: Any]]()
        return model
    }

    class func myAccount(_ dict: [String: Any]?) -> HomeCollectionCellModel {
        let model = HomeCollectionCellModel()
        model.title = "个人账户"
        model.subTitle = "总数量"
        model.accountNum = "0.00"
        model.unitStr = "CROS"
        model.walletName = "可用数量"
        model.walletCode = "0.0000 CROS"
        model.showMoreBtn = false
        model.showQRCodeBtn = false
        model.gradientColors = [UIColor(rgb: 0x04cadd).cgColor, UIColor(rgb: 0x00a0dd).cgColor]
        return model
    }

    class func mineralAccount(_ dict: [String: Any]?) -> HomeCollectionCellModel {
        let model = HomeCollectionCellModel()
        model.title = "矿产账户"
        model.subTitle = "总数量"
        model.accountNum = "0.00"
        model.unitStr = "CROS"
        model.walletName = "可用数量"
        model.walletCode = "0.0000 CROS"
        model.showMoreBtn = false
        model.showQRCodeBtn = false
        model.gradientColors = [UIColor(rgb: 0xead29e).cgColor, UIColor(rgb: 0xc3a36d).cgColor]
        return model
    }
}
