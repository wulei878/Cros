//
//  WebViewController.swift
//  Cros
//
//  Created by owen on 2018/8/8.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import dsBridge

class WebViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        webview.navigationDelegate = self
        webview.addJavascriptObject(JSEventAPI(), namespace: nil)
        webview.setDebugMode(true)
        webview.customJavascriptDialogLabelTitles(["alertTitle": "Notification", "alertBtn": "OK"])
        webview.scrollView.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
            self?.webview.reload()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebPage()
        navigationController?.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    func loadWebPage() {
        webview.loadUrl(url)
//        webview.callHandler("addValue", arguments: [param])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - getter and setter
    fileprivate let webview: DWKWebView = {
        let webview = DWKWebView()
        return webview
    }()
    var url = ""
    var param: [String: Any]?
    static let shard = WebViewController()
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}