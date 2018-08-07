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
        layoutViews()
        collectionView.delegate = self
        collectionView.dataSource = self
        homeCollectionViewModel.delegate = self
        loginModel.delegate = self
        loginModel.checkUniqueId()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSucceed), name: kLoginSucceedNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        tableView.mj_header = RefreshHeader(refreshingTarget: self, refreshingAction: #selector(refreshListData))
        tableView.mj_footer = RefreshFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreData))
        tableView.tableFooterView = UIView()
        return tableView
    }

    func showUnloginView() {
        if currentPage == 1 {
            if let unloginView = self.myAccountUnloginView {
                unloginView.isHidden = false
            } else {
                let unloginView = UnloginView()
                unloginView.loginBtn.addTarget(self, action: #selector(gotoLoginVC), for: .touchUpInside)
                myAccountListView.addSubview(unloginView)
                unloginView.snp.makeConstraints { (make) in
                    make.top.left.width.height.equalTo(myAccountListView)
                }
                myAccountUnloginView = unloginView
            }
        }
        if currentPage == 2 {
            if let unloginView = self.mineralAccountUnloginView {
                unloginView.isHidden = false
            } else {
                let unloginView = UnloginView()
                unloginView.loginBtn.addTarget(self, action: #selector(gotoLoginVC), for: .touchUpInside)
                mineralListView.addSubview(unloginView)
                unloginView.snp.makeConstraints { (make) in
                    make.top.left.width.height.equalTo(mineralListView)
                }
                mineralAccountUnloginView = unloginView
            }
        }
    }

    // MARK: - event response
    @objc func gotoLoginVC() {
        present(UINavigationController(rootViewController: PhoneLoginViewController()), animated: true, completion: nil)
    }

    @objc func refreshListData() {
        if currentPage == 0 {
            transactionListView.mj_header.endRefreshing()
            guard let address = homeCollectionViewModel.currentWalletAddress else { return }
            transactionListModels.removeAll()
            homeCollectionViewModel.getTransaction(walletAddress: address)
        } else if currentPage == 1 {
            myAccountListView.mj_header.endRefreshing()
            homeCollectionViewModel.getMyAccount()
        } else if currentPage == 2 {
            mineralListView.mj_header.endRefreshing()
            homeCollectionViewModel.getMineralAccount()
        }
    }
    @objc func loadMoreData() {

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

    var homeCollectionViewCellModels: [HomeCollectionCellModel] = [HomeCollectionCellModel.transaction(nil), HomeCollectionCellModel.myAccount(nil), HomeCollectionCellModel.mineralAccount(nil)]
    let homeCollectionViewModel = HomeCollectionViewModel()
    let homeListTableViewModel = HomeListTableViewModel()
    let walletListViewModel = HomeWalletListViewModel()
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
    var transactionListModels = [HomeListTableCellModel]()
    var myAccountListModels = [HomeListTableCellModel]()
    var mineralListModels = [HomeListTableCellModel]()
    var currentPage = 0 {
        didSet {
            indicatorView.currenIndex = currentPage
            listsScrollView.setContentOffset(CGPoint(x: CGFloat(currentPage) * listsScrollView.width, y: 0), animated: true)
            guard currentPage > 0 else { return }
            guard loginModel.isLogin() else {
                showUnloginView()
                return
            }
            if currentPage == 1, homeCollectionViewModel.myAccount.count == 0 {
                homeCollectionViewModel.getMyAccount()
            }
            if currentPage == 2, homeCollectionViewModel.mineralAccount.count == 0 {
                homeCollectionViewModel.getMineralAccount()
            }
        }
    }
    let loginModel = LoginModel()
    var myAccountUnloginView: UnloginView?
    var mineralAccountUnloginView: UnloginView?
    var drawer: HomeRightDrawer?
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: homeCollectionViewCellWidth, height: 145)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 21)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HomeCollectionViewCell.self), for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let model = homeCollectionViewCellModels[indexPath.row]
        cell.configData(title: model.title, subTitle: model.subTitle, accountNum: model.accountNum, unitStr: model.unitStr, walletName: model.walletName, walletCode: model.walletCode, showMoreBtn: model.showMoreBtn, showQRCodeBtn: model.showQRCodeBtn, gradientColors: model.gradientColors)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCollectionViewCellModels.count
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
}

// MARK: - UIScrollViewDelegate
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

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeListTableViewCell.self), for: indexPath) as? HomeListTableViewCell else { return UITableViewCell() }
        if tableView == transactionListView {
            let cellModel = transactionListModels[indexPath.row]
            cell.configData(coinImageURLStr: cellModel.coinImageURLStr, coinTitle: cellModel.coinTitle, amount: cellModel.amount, marketValue: cellModel.marketValue, unitPrice: cellModel.unitPrice)
        } else if tableView == myAccountListView {
            let cellModel = transactionListModels[indexPath.row]
            cell.configData(coinImageURLStr: cellModel.coinImageURLStr, coinTitle: cellModel.coinTitle, amount: cellModel.amount, marketValue: cellModel.marketValue, unitPrice: cellModel.unitPrice)
        } else if tableView == mineralListView {
            let cellModel = transactionListModels[indexPath.row]
            cell.configData(coinImageURLStr: cellModel.coinImageURLStr, coinTitle: cellModel.coinTitle, amount: cellModel.amount, marketValue: cellModel.marketValue, unitPrice: cellModel.unitPrice)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == transactionListView {
            return transactionListModels.count
        } else if tableView == myAccountListView {
            return myAccountListModels.count
        } else if tableView == mineralListView {
            return mineralListModels.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

// MARK: - HomeCollectionViewCellDelegate
extension HomeViewController: HomeCollectionViewCellDelegate {
    func homeCollectionViewCellGotoQRCodePage() {
    }
    func homeCollectionViewCellMoreAction() {
        if let drawer = self.drawer {
            drawer.isHidden = false
            drawer.reloadData()
        } else {
            let drawer = HomeRightDrawer()
            view.addSubview(drawer)
            drawer.snp.makeConstraints { (make) in
                make.edges.equalTo(0)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissDrawer))
            drawer.leftMask.addGestureRecognizer(tap)
            self.drawer = drawer
            self.drawer?.accounts = self.walletListViewModel
            self.drawer?.delegate = self
        }
    }

    @objc func dismissDrawer() {
        guard let drawer = self.drawer else { return }
        drawer.isHidden = true
    }
}

// MARK: - LoginModelDelegate
extension HomeViewController: LoginModelDelegate {
    func getUniqueIdCompleted(_ errorCode: Int, _ errorMsg: String) {
        guard errorCode == 0 else {
            HUD.showText(errorMsg, in: view)
            return
        }
        walletListViewModel.getWalletList()
        walletListViewModel.delegate = self
    }

    @objc func loginSucceed() {
        if currentPage == 1 {
            myAccountUnloginView?.isHidden = true
            homeCollectionViewModel.getMyAccount()
        }
        if currentPage == 2 {
            mineralAccountUnloginView?.isHidden = true
            homeCollectionViewModel.getMineralAccount()
        }
    }
}

// MARK: - HomeCollectionViewModelDelegate
extension HomeViewController: HomeCollectionViewModelDelegate {
    func getTransactionCompleted(_ errorCode: Int, errorMessage: String?) {
        guard errorCode == 0 else {
            HUD.showText(errorMessage ?? "", in: view)
            return
        }
        let myTransaction = HomeCollectionCellModel.transaction(homeCollectionViewModel.myTransaction)
        homeCollectionViewCellModels[0] = myTransaction
        homeListTableViewModel.myTransaction = myTransaction.focusCoins
        for item in homeListTableViewModel.myTransaction {
            let model = HomeListTableCellModel.transaction(item)
            transactionListModels.append(model)
        }
        collectionView.reloadData()
        transactionListView.reloadData()
    }

    func getMyAccountCompleted(_ errorCode: Int, errorMessage: String?) {
        guard errorCode == 0 else {
            HUD.showText(errorMessage ?? "", in: view)
            return
        }
        homeCollectionViewCellModels[1] = HomeCollectionCellModel.myAccount(homeCollectionViewModel.myAccount)
        collectionView.reloadData()
        myAccountListView.reloadData()
    }

    func getMineralAccountCompleted(_ errorCode: Int, errorMessage: String?) {
        guard errorCode == 0 else {
            HUD.showText(errorMessage ?? "", in: view)
            return
        }
        homeCollectionViewCellModels[2] = HomeCollectionCellModel.mineralAccount(homeCollectionViewModel.mineralAccount)
        collectionView.reloadData()
        mineralListView.reloadData()
    }
}

// MARK: - HomeWalletListViewModelDelegate
extension HomeViewController: HomeWalletListViewModelDelegate {
    func getWalletListCompleted(_ errorCode: Int, errorMessage: String) {
        guard errorCode == 0 else {
            HUD.showText(errorMessage, in: view)
            return
        }
        guard walletListViewModel.walletList.count > 0 else { return }
        let walletAddress = walletListViewModel.walletList[0].walletAddress
        homeCollectionViewModel.getTransaction(walletAddress: walletAddress)
    }
}

// MARK: - HomeRightDrawerDelegate
extension HomeViewController: HomeRightDrawerDelegate {
    func homeRightDrawerCreateWallet() {
    }

    func homeRightDrawerScanAction() {
    }

    func homeRightDrawerChangeWallet(walletAddress: String) {
        transactionListModels.removeAll()
        homeCollectionViewModel.getTransaction(walletAddress: walletAddress)
    }
}
