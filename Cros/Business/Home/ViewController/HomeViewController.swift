//
//  HomeViewController.swift
//  Alamofire
//
//  Created by owen on 2018/7/13.
//

import UIKit
import SnapKit

public class HomeViewController: UIViewController {

    // MARK: - life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        layoutViews()
        homeCollectionViewModel.delegate = self
        collectionView.mj_header = RefreshHeader {[weak self] in
            self?.homeCollectionViewModel.getFileList(page: 0, count: 5)
        }
        collectionView.mj_header.beginRefreshing()
    }

    func layoutViews() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    // MARK: - event response

    // MARK: - getter and setter
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HomeCollectionViewCell.self))
        collectionView.backgroundColor = .white
        return collectionView
    }()

    var homeCollectionViewCellModels = [HomeCollectionViewCellModel]()
    let homeCollectionViewModel = HomeCollectionViewModel()
}

// MARK: - delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 2 - 10
        return CGSize(width: width, height: width)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeCollectionViewCell.self), for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let cellModel = homeCollectionViewCellModels[indexPath.row]
        cell.configData(title: cellModel.title, url: cellModel.coverImageURLString)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCollectionViewModel.fileList.count
    }
}

extension HomeViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = homeCollectionViewCellModels[indexPath.row]
    }
}

extension HomeViewController: HomeCollectionViewModelDelegate {
    func getFileListCompleted(_ errorCode: Int, errorMessage: String?) {
        collectionView.mj_header.endRefreshing()
        guard errorCode == 0 else {
            HUD.showText(errorMessage as? String ?? "", in: view)
            return
        }
        for element in homeCollectionViewModel.fileList {
            guard let ele = element as? [String: Any] else { break }
            let homeCollectionViewCellModel = HomeCollectionViewCellModel(dic: ele)
            homeCollectionViewCellModels.append(homeCollectionViewCellModel)
        }
        self.collectionView.reloadData()
    }
}
