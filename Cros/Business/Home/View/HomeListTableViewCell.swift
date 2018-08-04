//
//  HomeListTableViewCell.swift
//  Cros
//
//  Created by Owen on 2018/8/4.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

class HomeListTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coinImageView)
        contentView.addSubview(coinTitleLbl)
        contentView.addSubview(AmountLbl)
        contentView.addSubview(marketValueLbl)
        contentView.addSubview(unitPriceLbl)
        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func layoutViews() {
        coinImageView.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.top.equalTo(25)
            make.width.height.equalTo(46)
        }
        coinTitleLbl.snp.makeConstraints { (make) in
            make.top.equalTo(18)
            make.left.equalTo(coinImageView.snp.right).offset(15)
        }
        AmountLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(coinTitleLbl)
            make.right.equalTo(-21)
            make.left.greaterThanOrEqualTo(coinTitleLbl.snp.right).offset(20)
        }
        marketValueLbl.snp.makeConstraints { (make) in
            make.left.equalTo(coinTitleLbl)
            make.top.equalTo(coinTitleLbl.snp.bottom).offset(15)
        }
        unitPriceLbl.snp.makeConstraints { (make) in
            make.right.equalTo(AmountLbl)
            make.centerY.equalTo(marketValueLbl)
            make.left.greaterThanOrEqualTo(marketValueLbl.snp.right).offset(20)
        }
        coinImageView.layer.cornerRadius = 23
    }

    func configData(coinImageURLStr: String, coinTitle: String, amount: String, marketValue: String, unitPrice: String) {
        coinImageView.kf.setImage(with: URL(string: coinImageURLStr))
        coinTitleLbl.text = coinTitle
        AmountLbl.text = amount
        marketValueLbl.text = marketValue
        unitPriceLbl.text = unitPrice
    }

    let coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor(rgb: 0xebf4f7).cgColor
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        return imageView
    }()
    let coinTitleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(rgb: 0x424968)
        return label
    }()
    let AmountLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(rgb: 0x424968)
        return label
    }()
    let marketValueLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(rgb: 0x8c90a1)
        return label
    }()
    let unitPriceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(rgb: 0x8c90a1)
        return label
    }()
}
