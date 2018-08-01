//
//  HomeCollectionViewCellModel.swift
//  Alamofire
//
//  Created by owen on 2018/7/16.
//

import UIKit

class HomeCollectionViewCellModel: NSObject {
    var title: String!
    var coverImageURLString: String!
    var fileUrl: String!
    override init() {
        super.init()
    }

    init(dic: [String: Any]) {
        title = dic["title"] as? String ?? ""
        coverImageURLString = dic["coverImageURLString"] as? String ?? ""
        fileUrl = dic["url"] as? String ?? ""
        super.init()
    }
}
