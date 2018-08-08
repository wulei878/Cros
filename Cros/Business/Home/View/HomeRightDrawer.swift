//
//  HomeRightDrawer.swift
//  Cros
//
//  Created by owen on 2018/8/6.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit

protocol HomeRightDrawerDelegate: class {
    func homeRightDrawerScanAction()
    func homeRightDrawerCreateWallet()
    func homeRightDrawerChangeWallet(walletAddress: String)
}

class HomeRightDrawer: UIView {
    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor(rgb: 0x080808, a: 0.3)
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(223)
            make.top.right.bottom.equalTo(0)
        }
        addSubview(leftMask)
        leftMask.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(tableView.snp.left)
        }
        let top = safeAreaTop()
        tableView.contentInset = UIEdgeInsets(top: top == 0 ? 49 : top, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func reloadData() {
        tableView.reloadData()
    }

    func safeAreaTop() -> CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            return window?.safeAreaInsets.top ?? 0
        }
        return 0
    }

    weak var delegate: HomeRightDrawerDelegate?
    let leftMask: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var accounts = HomeWalletListViewModel()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(AccountCell.self, forCellReuseIdentifier: String(describing: AccountCell.self))
        tableView.register(ActionCell.self, forCellReuseIdentifier: String(describing: ActionCell.self))
        return tableView
    }()

    private class AccountCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            contentView.addSubview(headerImage)
            contentView.addSubview(nameLbl)
            headerImage.snp.makeConstraints { (make) in
                make.centerY.equalTo(contentView)
                make.height.width.equalTo(34)
                make.left.equalTo(20)
            }
            headerImage.layer.cornerRadius = 17
            nameLbl.snp.makeConstraints { (make) in
                make.left.equalTo(headerImage.snp.right).offset(15)
                make.centerY.equalTo(headerImage)
                make.right.lessThanOrEqualTo(-20)
            }
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        func configData(headerImageStr: String, name: String) {
            headerImage.kf.setImage(with: URL(string: headerImageStr))
            nameLbl.text = name
        }

        let headerImage: UIImageView = {
            let imageView = UIImageView()
            imageView.clipsToBounds = true
            return imageView
        }()
        let nameLbl: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(rgb: 0x212121)
            label.font = UIFont.systemFont(ofSize: 15)
            return label
        }()
        override var isSelected: Bool {
            didSet {
                backgroundColor = isSelected ? UIColor(rgb: 0xececec) : .white
            }
        }
    }
    private class ActionCell: UITableViewCell {
        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            contentView.addSubview(scanImageView)
            contentView.addSubview(actionLbl)
            scanImageView.snp.makeConstraints { (make) in
                make.left.equalTo(20)
                make.centerY.equalTo(contentView)
            }
            actionLbl.snp.makeConstraints { (make) in
                make.left.equalTo(scanImageView.snp.right).offset(15)
                make.centerY.equalTo(contentView)
                make.right.lessThanOrEqualTo(-20)
            }
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        func configData(image: UIImage, name: String) {
            scanImageView.image = image
            actionLbl.text = name
        }
        let scanImageView: UIImageView = {
            let imageView = UIImageView(image: #imageLiteral(resourceName: "back"))
            return imageView
        }()
        let actionLbl: UILabel = {
            let label = UILabel()
            label.textColor = UIColor(rgb: 0x212121)
            label.font = UIFont.systemFont(ofSize: 15)
            return label
        }()
    }
}

extension HomeRightDrawer: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return accounts.walletList.count
        case 1:
            return 1
        case 2:
            return 2
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch indexPath.section {
        case 0:
            if let tableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountCell.self), for: indexPath) as? AccountCell {
                let model = accounts.walletList[indexPath.row]
                tableCell.configData(headerImageStr: model.headerImageStr, name: model.walletName)
                tableCell.isSelected = model.isSelected
                cell = tableCell
            }
        case 1:
            let tableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            let line = UIView.bottomLine()
            tableCell.contentView.addSubview(line)
            line.snp.makeConstraints { (make) in
                make.left.right.centerY.equalTo(tableCell.contentView)
            }
            cell = tableCell
        case 2:
            if let tableCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ActionCell.self), for: indexPath) as? ActionCell {
                if indexPath.row == 0 {
                    tableCell.configData(image: #imageLiteral(resourceName: "scan_icon"), name: "扫一扫")
                } else if indexPath.row == 1 {
                    tableCell.configData(image: #imageLiteral(resourceName: "create_wallet_icon"), name: "创建钱包")
                }
                cell = tableCell
            }
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
}
extension HomeRightDrawer: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 53
        case 1:
            return 30
        case 2:
            return 44
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            var walletAddress: String?
            for (index, _) in accounts.walletList.enumerated() {
                accounts.walletList[index].isSelected = index == indexPath.row
                if index == indexPath.row {
                    walletAddress = accounts.walletList[index].walletAddress
                }
            }
            tableView.reloadData()
            guard let address = walletAddress else { return }
            accounts.currentWalletIndex = indexPath.row
            delegate?.homeRightDrawerChangeWallet(walletAddress: address)
        case 2:
            if indexPath.row == 0 {
                delegate?.homeRightDrawerScanAction()
            } else if indexPath.row == 1 {
                delegate?.homeRightDrawerCreateWallet()
            }
        default:
            break
        }
    }
}
