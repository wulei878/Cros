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
    var walletCode = ""
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
        let nf = NumberFormatter()
        nf.twoDigits()
        if let totalValue = dict?["totalValue"] as? String {
            model.accountNum = nf.string(from: NSDecimalNumber(string: totalValue)) ?? "0.00"
        }
        model.walletName = dict?["walletName"] as? String ?? "暂无钱包"
        model.walletCode = dict?["walletAddress"] as? String ?? "暂无地址"
        model.focusCoins = dict?["focusCoin"] as? [[String: Any]] ?? [[String: Any]]()
        return model
    }

    class func myAccount(_ dict: [String: Any]?) -> HomeCollectionCellModel {
        let model = HomeCollectionCellModel()
        model.title = "个人账户"
        model.subTitle = "总数量"
        model.unitStr = "CROS"
        model.walletName = "可用数量"
        model.showMoreBtn = false
        model.showQRCodeBtn = false
        model.gradientColors = [UIColor(rgb: 0x04cadd).cgColor, UIColor(rgb: 0x00a0dd).cgColor]
        let nf = NumberFormatter()
        nf.fourDigits()
        if let totalValue = dict?["totalValue"] as? Double {
            model.accountNum = String(format: "%.4f", totalValue)
        }
        if let totalAvailable = dict?["totalAvailable"] as? Double {
            let value = String(format: "%.4f", totalAvailable)
            model.walletCode = value + " CROS"
        } else {
            model.walletCode = "0.0000 CROS"
        }
        model.focusCoins = dict?["indexList"] as? [[String: Any]] ?? [[String: Any]]()
        return model
    }

    class func mineralAccount(_ dict: [String: Any]?) -> HomeCollectionCellModel {
        let model = HomeCollectionCellModel()
        model.title = "矿产账户"
        model.subTitle = "总数量"
        model.unitStr = "CROS"
        model.walletName = "可用数量"
        model.showMoreBtn = false
        model.showQRCodeBtn = false
        model.gradientColors = [UIColor(rgb: 0xead29e).cgColor, UIColor(rgb: 0xc3a36d).cgColor]
        let nf = NumberFormatter()
        nf.fourDigits()
        if let totalValue = dict?["totalUsePrice"] as? Double {
            model.accountNum = String(format: "%.4f", totalValue)
        }
        if let totalAvailable = dict?["totalFindPrice"] as? Double {
            model.walletCode = String(format: "%.4f CROS", totalAvailable)
        } else {
            model.walletCode = "0.0000 CROS"
        }
        model.focusCoins = dict?["list"] as? [[String: Any]] ?? [[String: Any]]()
        return model
    }
}

extension NumberFormatter {
    func fourDigits() {
        minimumFractionDigits = 4
        maximumFractionDigits = 4
        minimumIntegerDigits = 1
    }

    func twoDigits() {
        minimumFractionDigits = 2
        maximumFractionDigits = 2
        minimumIntegerDigits = 1
    }
}
