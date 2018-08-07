//
//  RefreshHeader.swift
//  Alamofire
//
//  Created by owen on 2018/7/24.
//

import MJRefresh

class RefreshHeader: MJRefreshNormalHeader {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.stateLabel.isHidden = true
        self.lastUpdatedTimeLabel.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class RefreshFooter: MJRefreshAutoNormalFooter {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.stateLabel.isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
