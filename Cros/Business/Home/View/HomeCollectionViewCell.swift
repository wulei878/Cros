//
//  HomeCollectionViewCell.swift
//  Alamofire
//
//  Created by owen on 2018/7/16.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(coverView)
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        layoutViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func layoutViews() {
        containerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(40)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.left.equalTo(10)
            make.right.lessThanOrEqualTo(-10)
        }
        coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    func configData(title: String, url: String) {
        titleLabel.text = title
        coverView.kf.setImage(with: URL(string: url))
    }

    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        return titleLabel
    }()
    let coverView: UIImageView = {
        let coverView = UIImageView()
        coverView.isUserInteractionEnabled = true
        return coverView
    }()
    let containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        return containerView
    }()
}
