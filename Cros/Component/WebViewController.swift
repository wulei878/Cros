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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadWebPage()
        navigationController?.isNavigationBarHidden = !showNavi
        webview.addJavascriptObject(JSEventAPI(), namespace: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        showNavi = false
        webview.removeJavascriptObject(nil)
    }

    func loadWebPage() {
        webview.loadUrl(url)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - getter and setter
    fileprivate let webview: WebView = {
        let webview = WebView()
        return webview
    }()
    var url = ""
    var param: [String: Any]?
    var showNavi = false
    static let shard = WebViewController()
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}
