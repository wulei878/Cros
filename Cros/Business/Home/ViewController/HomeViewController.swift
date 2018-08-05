//
//  HomeViewController.swift
//  Alamofire
//
//  Created by owen on 2018/7/13.
//

import UIKit
import SnapKit

fileprivate let accountCount = 3
fileprivate let homeCollectionViewCellWidth = UIScreen.main.bounds.size.width - 42
fileprivate let homeCollectionViewCellPadding: CGFloat = 13
class HomeViewController: UIViewController {

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        layoutViews()
        homeCollectionViewModel.delegate = self
        loginModel.checkUniqueId()
        loginModel.delegate = self
        if !UserInfo.shard.isLogin() {
            self.present(UINavigationController(rootViewController: PhoneLoginViewController()), animated: true, completion: nil)
        }
//        collectionView.mj_header = RefreshHeader {[weak self] in
//            self?.homeCollectionViewModel.getFileList(page: 0, count: 5)
//        }
//        collectionView.mj_header.beginRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    func layoutViews() {
        let container = UIView()
        container.backgroundColor = .white
        view.addSubview(container)
        container.addSubview(collectionView)
        container.addSubview(indicatorView)
        container.addSubview(listsScrollView)
        transactionListView = tableViewFactory()
        myAccountListView = tableViewFactory()
        mineralListView = tableViewFactory()
        listsScrollView.addSubview(transactionListView)
        listsScrollView.addSubview(myAccountListView)
        listsScrollView.addSubview(mineralListView)
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaInsets.top == 0 ? 40 : safeAreaInsets.top + 10)
            make.left.right.equalTo(0)
            make.height.equalTo(170)
        }
        indicatorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(container)
            make.top.equalTo(collectionView.snp.bottom)
        }
        listsScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom).offset(17)
            make.left.right.bottom.equalTo(0)
        }
        transactionListView.snp.makeConstraints { (make) in
            make.left.top.bottom.width.height.equalTo(listsScrollView)
        }
        myAccountListView.snp.makeConstraints { (make) in
            make.left.equalTo(transactionListView.snp.right)
            make.top.width.height.equalTo(transactionListView)
        }
        mineralListView.snp.makeConstraints { (make) in
            make.left.equalTo(myAccountListView.snp.right)
            make.top.width.height.equalTo(transactionListView)
            make.right.equalTo(0)
        }
    }

    func tableViewFactory() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(HomeListTableViewCell.self, forCellReuseIdentifier: String(describing: HomeListTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
    // MARK: - getter and setter
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = homeCollectionViewCellPadding
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HomeCollectionViewCell.self))
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    var homeCollectionViewCellModels:[Any] = [HomeTransactionCellModel(),HomeMyAccountCellModel(),HomeMineralCellModel()]
    let homeCollectionViewModel = HomeCollectionViewModel()
    let indicatorView: HomeIndicatorView = {
        let view = HomeIndicatorView()
        view.indicatorCount = accountCount
        view.currenIndex = 0
        return view
    }()
    let listsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    var transactionListView: UITableView!
    var myAccountListView: UITableView!
    var mineralListView: UITableView!
    var currentPage = 0 {
        didSet {
            indicatorView.currenIndex = currentPage
            listsScrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * listsScrollView.width, y: 0), animated: true)
        }
    }
    let loginModel = LoginModel()
}

// MARK: - delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: homeCollectionViewCellWidth, height: 145)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeCollectionViewCell.self), for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            let model = homeCollectionViewCellModels[indexPath.row] as? HomeTransactionCellModel
            cell.configData(title: cellModel.title, subTitle: cellModel.subTitle, accountNum: cellModel.accountNum, unitStr: cellModel.unitStr, walletName: cellModel.walletName, walletCode: cellModel.walletCode, showMoreBtn: cellModel.showQRCodeBtn, showQRCodeBtn: cellModel.showQRCodeBtn, gradientColors: cellModel.gradientColors)
        }
        let cellModel = HomeTransactionCellModel()

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCollectionViewCellModels.count
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let element = homeCollectionViewCellModels[indexPath.row]
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == collectionView else { return }
        let cellWidth = homeCollectionViewCellWidth
        let cellPadding = homeCollectionViewCellPadding
        var page = Int((scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1)
        page = velocity.x > 0 ? page + 1 : page - 1
        page = [page, 0].max() ?? 0
        let newOffset = CGFloat(page) * (cellWidth + cellPadding)
        targetContentOffset.pointee.x = newOffset
        currentPage = page
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListTableViewCell.self), for: indexPath) as? HomeListTableViewCell else { return UITableViewCell() }
        let cellModel = HomeListTableViewModel()
        cell.configData(coinImageURLStr: cellModel.coinImageURLStr, coinTitle: cellModel.coinTitle, amount: cellModel.amount, marketValue: cellModel.marketValue, unitPrice: cellModel.unitPrice)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension HomeViewController: LoginModelDelegate {
    func getUniqueIdCompleted(_ errorCode: Int, _ errorMsg: String) {
        guard errorCode == 0 else {
            HUD.showText(errorMsg, in: view)
            return
        }
    }
}

extension HomeViewController: HomeCollectionViewModelDelegate {
    func getTransactionCompleted(_ errorCode: Int, errorMessage: String?) {
    }

    func getMyAccountCompleted(_ errorCode: Int, errorMessage: String?) {
    }

    func getMineralAccountCompleted(_ errorCode: Int, errorMessage: String?) {
    }

}
