//
//  MineViewController.swift
//  Cros
//
//  Created by Owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import dsBridge

class MineViewController: UIViewController {
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        let urlStr = "http://10.109.20.33:8080" + "/#/userPage?\(arc4random())"
//        let urlStr = "http://localhost:3000"
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webview.load(request)
        }
        webview.navigationDelegate = self
        webview.addJavascriptObject(JSEventAPI(), namespace: nil)
        webview.setDebugMode(true)
        webview.customJavascriptDialogLabelTitles(["alertTitle": "Notification", "alertBtn": "OK"])
        webview.scrollView.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
            self?.webview.reload()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: kLoginSucceedNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func didLogin() {
        webview.reload()
    }
    // MARK: - getter and setter
    fileprivate let webview: DWKWebView = {
        let webview = DWKWebView()
        return webview
    }()
}

extension MineViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("succeed")
        webview.scrollView.mj_header.endRefreshing()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
}
