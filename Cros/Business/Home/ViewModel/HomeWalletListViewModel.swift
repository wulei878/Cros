//
//  HomeWalletListViewModel.swift
//  Cros
//
//  Created by owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation

protocol HomeWalletListViewModelDelegate: class {
    func getWalletListCompleted(_ errorCode: Int, errorMessage: String)
}

class HomeWalletListViewModel {
    var walletList = [HomeWalletAccountModel]()
    weak var delegate: HomeWalletListViewModelDelegate?

    func getWalletList() {
        CRORequest.shard.start(APIPath.walletList, needPrivateKey: true) { [weak self](errCode, data, msg) in
            guard errCode == 0, let obj = data as? [[String: Any]] else {
                self?.delegate?.getWalletListCompleted(-1, errorMessage: msg)
                return
            }
            for item in obj {
                var account = HomeWalletAccountModel()
                account.walletId = item["walletId"] as? Int ?? 0
                account.walletName = item["walletName"] as? String ?? ""
                account.walletAddress = item["walletAddress"] as? String ?? ""
                self?.walletList.append(account)
            }
            self?.delegate?.getWalletListCompleted(0, errorMessage: "")
        }
    }
}

struct HomeWalletAccountModel {
    var headerImageStr = ""
    var walletName = "松鼠大人"
    var walletId = 0
    var walletAddress = ""
}
