//
//  MineViewController.swift
//  Cros
//
//  Created by Owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class MineViewController: UIViewController {
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        let urlStr = baseURL + "wallet-web/#/userPage"
//        let urlStr = "http://localhost:3000"
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            webview.load(request)
        }
        webview.navigationDelegate = self
        webview.configuration.userContentController.add(self, name: "getToken")
        webview.configuration.userContentController.add(self, name: "getUUID")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        webview.reload()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - getter and setter
    fileprivate let webview: WebView = {
        let webview = WebView()
        return webview
    }()
}

extension MineViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webview.evaluateJavaScript("getUUID('\(UserInfo.shard.token)')") { (data, error) in
            print(data, error)
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
}

extension MineViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "getToken" {

        }
    }
}
