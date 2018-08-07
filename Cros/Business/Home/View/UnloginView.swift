//
//  UnloginView.swift
//  Cros
//
//  Created by Owen on 2018/8/7.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class UnloginView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubview(unloginImageView)
        addSubview(tipsLbl)
        addSubview(loginBtn)
        unloginImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 166, height: 110))
            make.top.equalTo(20)
            make.centerX.equalTo(self)
        }
        tipsLbl.snp.makeConstraints { (make) in
            make.top.equalTo(unloginImageView.snp.bottom).offset(6)
            make.centerX.equalTo(unloginImageView)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(tipsLbl.snp.bottom).offset(70)
            make.centerX.equalTo(unloginImageView)
            make.size.equalTo(CGSize(width: 210, height: 45))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    let unloginImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "unlogin_icon"))
        return imageView
    }()
    let tipsLbl: UILabel = {
        let label = UILabel()
        label.text = "空空如也，需要先登录账户哟~"
        label.textColor = UIColor(rgb: 0xcccbce)
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    let loginBtn: UIButton = {
        let button = UIButton()
        button.customType("立即登录")
        button.layer.cornerRadius = 22.5
        return button
    }()
}
