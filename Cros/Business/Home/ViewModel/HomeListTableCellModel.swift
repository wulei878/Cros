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
    var contractAddress = ""

    class func transaction(_ dict: [String: Any]?) -> HomeListTableCellModel {
        let model = HomeListTableCellModel()
        model.coinImageURLStr = dict?["pic"] as? String ?? ""
        model.coinTitle = dict?["assetName"] as? String ?? ""
        if let price = dict?["price"] as? Double {
            model.marketValue = "≈" + String(format: "%.2f CNY", price)
        }
        if let assetValue = dict?["assetValue"] as? String {
            model.amount = String(format: "%.4Lf", NSDecimalNumber(string: assetValue))
        }
        if let unitPrice = dict?["CNY"] as? String {
            model.unitPrice = "≈" + String(format: "%.2Lf CNY", NSDecimalNumber(string: unitPrice))
        }
        return model
    }

    class func myAccount(_ dict: [String: Any]?) -> HomeListTableCellModel {
        let model = HomeListTableCellModel()
        model.coinImageURLStr = dict?["pic"] as? String ?? ""
        model.coinTitle = dict?["assetName"] as? String ?? ""
        if let price = dict?["price"] as? Double {
            model.marketValue = "≈" + String(format: "%.2f CNY", price)
        }
        if let assetValue = dict?["assetValue"] as? String {
            model.amount = String(format: "%.4Lf", NSDecimalNumber(string: assetValue))
        }
        if let unitPrice = dict?["assetPrice"] as? String {
            model.unitPrice = "≈" + String(format: "%.2Lf CNY", NSDecimalNumber(string: unitPrice))
        }
        return model
    }

    class func mineralAccount(_ dict: [String: Any]?) -> HomeListTableCellModel {
        let model = HomeListTableCellModel()
        model.coinImageURLStr = dict?["pic"] as? String ?? ""
        model.coinTitle = dict?["name"] as? String ?? ""
        if let price = dict?["price"] as? Double {
            model.marketValue = "≈" + String(format: "%.2f CNY", price)
        }
        if let assetValue = dict?["availableBalance"] as? String {
            model.amount = String(format: "%.4Lf", NSDecimalNumber(string: assetValue))
        }
        if let unitPrice = dict?["assetPrice"] as? String {
            model.unitPrice = "≈" + String(format: "%.2Lf CNY", NSDecimalNumber(string: unitPrice))
        }
        return model
    }
}
