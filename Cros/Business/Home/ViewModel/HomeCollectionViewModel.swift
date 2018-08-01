//
//  HomeCollectionViewModel.swift
//  Alamofire
//
//  Created by owen on 2018/7/13.
//

import UIKit

protocol HomeCollectionViewModelDelegate: class {
    func getFileListCompleted(_ errorCode: Int, errorMessage: String?)
}

public class HomeCollectionViewModel: NSObject {
    var fileList = [Any]()
    weak var delegate: HomeCollectionViewModelDelegate?

    public func getFileList(page: Int, count: Int) {
        CRORequest.shard.start("") { [weak self](errorCode, value) in
            guard errorCode == 0,
                let data = value as? [String: Any],
                let fileList = data["data"] as? [Any] else {
                    self?.delegate?.getFileListCompleted(-1, errorMessage: "网络不给力，请稍后重试")
                    return
            }
            self?.fileList.removeAll()
            self?.fileList.append(contentsOf: fileList)
            self?.delegate?.getFileListCompleted(0, errorMessage: nil)
        }
    }
}
