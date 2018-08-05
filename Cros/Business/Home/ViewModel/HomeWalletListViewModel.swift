//
//  HomeWalletListViewModel.swift
//  Cros
//
//  Created by owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import Foundation

protocol HomeWalletListViewModelDelegate: class {
    func getWalletListCompleted(_ errorCode: Int, errorMessage: String?)
}

class HomeWalletListViewModel {
    var walletList = [[String: Any]]()
    weak var delegate: HomeWalletListViewModelDelegate?

    func getWalletList() {
        CRORequest.shard.start(APIPath.walletList, needPrivateKey: true) { [weak self](errCode, data, msg) in
            guard errCode == 0, let obj = data as? [[String: Any]] else {
                self?.delegate?.getWalletListCompleted(-1, errorMessage: msg)
                return
            }
            self?.walletList = obj
            self?.delegate?.getWalletListCompleted(0, errorMessage: nil)
        }
    }
}
