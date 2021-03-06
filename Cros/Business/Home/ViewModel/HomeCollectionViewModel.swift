//
//  HomeCollectionViewModel.swift
//  Alamofire
//
//  Created by owen on 2018/7/13.
//

import UIKit
import Alamofire

protocol HomeCollectionViewModelDelegate: class {
    func getTransactionCompleted(_ errorCode: Int, errorMessage: String?)
    func getMyAccountCompleted(_ errorCode: Int, errorMessage: String?)
    func getMineralAccountCompleted(_ errorCode: Int, errorMessage: String?)
}

class HomeCollectionViewModel {
    var myTransaction = [String: Any]()
    var myAccount = [String: Any]()
    var mineralAccount = [String: Any]()
    weak var delegate: HomeCollectionViewModelDelegate?
    var currentWalletAddress: String?

    func getTransaction(walletAddress: String) {
        currentWalletAddress = walletAddress
        CRORequest.shard.start(APIPath.transaction, parameters: ["walletAddress": walletAddress], needPrivateKey: true, encoding: URLEncoding.default, headers: ["content-type": "application/x-www-form-urlencoded"]) { [weak self](errCode, data, msg) in
            guard errCode == 0, let dic = data as? [String: Any] else {
                self?.delegate?.getTransactionCompleted(-1, errorMessage: msg)
                return
            }
            self?.myTransaction = dic
            self?.delegate?.getTransactionCompleted(0, errorMessage: nil)
        }
    }

    func getMyAccount() {
        CRORequest.shard.start(APIPath.myAccount, needAuthorization: true) { [weak self](errCode, data, msg) in
            guard errCode == 0, let dic = data as? [String: Any] else {
                self?.delegate?.getMyAccountCompleted(-1, errorMessage: msg)
                return
            }
            self?.myAccount = dic
            self?.delegate?.getMyAccountCompleted(0, errorMessage: nil)
        }
    }

    func getMineralAccount() {
        CRORequest.shard.start(APIPath.mineralAccount, needAuthorization: true) { [weak self](errCode, data, msg) in
            guard errCode == 0, let dic = data as? [String: Any] else {
                self?.delegate?.getMineralAccountCompleted(-1, errorMessage: msg)
                return
            }
            self?.mineralAccount = dic
            self?.delegate?.getMineralAccountCompleted(0, errorMessage: nil)
        }
    }
}
