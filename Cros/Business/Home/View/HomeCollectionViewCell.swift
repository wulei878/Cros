//
//  HomeCollectionViewCell.swift
//  Alamofire
//
//  Created by owen on 2018/7/16.
//

import UIKit
import Kingfisher

protocol HomeCollectionViewCellDelegate: class {
    func homeCollectionViewCellMoreAction()
    func homeCollectionViewCellGotoQRCodePage()
}

class HomeCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreBtn)
        contentView.addSubview(subTitleLbl)
        contentView.addSubview(accountNumLbl)
        contentView.addSubview(unitLbl)
        contentView.addSubview(walletNameLbl)
        contentView.addSubview(walletCodeLbl)
        contentView.addSubview(qrCodeBtn)
        layoutViews()
        layerMask.frame = contentView.bounds
        contentView.layer.insertSublayer(layerMask, at: 0)
        contentView.layer.cornerRadius = 3
        contentView.clipsToBounds = true
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        moreBtn.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        qrCodeBtn.addTarget(self, action: #selector(gotoQRCodePage), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func layoutViews() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(14)
        }
        moreBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.height.equalTo(44)
        }
        subTitleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        accountNumLbl.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLbl.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
        }
        unitLbl.snp.makeConstraints { (make) in
            make.left.equalTo(accountNumLbl.snp.right).offset(5)
            make.bottom.equalTo(accountNumLbl).offset(-4)
            make.right.lessThanOrEqualTo(-20)
        }
        walletNameLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(accountNumLbl.snp.bottom).offset(8)
        }
        walletCodeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.width.lessThanOrEqualTo(140)
            make.top.equalTo(walletNameLbl.snp.bottom).offset(3)
        }
        qrCodeBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(walletCodeLbl)
            make.width.height.equalTo(44)
            make.left.equalTo(walletCodeLbl.snp.right).offset(-8)
        }
    }

    func configData(title: String, subTitle: String, accountNum: String, unitStr: String, walletName: String, walletCode: String, showMoreBtn: Bool, showQRCodeBtn: Bool, gradientColors: [CGColor]) {
        titleLabel.text = title
        subTitleLbl.text = subTitle
        accountNumLbl.text = accountNum
        unitLbl.text = unitStr
        walletNameLbl.text = walletName
        walletCodeLbl.text = walletCode
        moreBtn.isHidden = !showMoreBtn
        qrCodeBtn.isHidden = !showQRCodeBtn
        layerMask.colors = gradientColors
        layer.shadowColor = gradientColors.first
    }

    // MARK: - event response
    @objc func moreAction() {
        delegate?.homeCollectionViewCellMoreAction()
    }

    @objc func gotoQRCodePage() {
        delegate?.homeCollectionViewCellGotoQRCodePage()
    }
    // MARK: - getter and setter
    weak var delegate: HomeCollectionViewCellDelegate?
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        return titleLabel
    }()
    let moreBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "home_more_icon"), for: .normal)
        return button
    }()
    let subTitleLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    let accountNumLbl: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        return label
    }()
    let unitLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    let walletNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.alpha = 0.9
        return label
    }()
    let walletCodeLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.alpha = 0.9
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    let qrCodeBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "home_qrcode_icon"), for: .normal)
        return button
    }()
    let layerMask: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        return layer
    }()
}
