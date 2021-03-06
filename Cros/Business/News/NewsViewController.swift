//
//  NewsViewController.swift
//  Cros
//
//  Created by Owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        webview.loadUrl(h5BaseURL+"infoPage")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        webview.addJavascriptObject(JSEventAPI(), namespace: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        webview.removeJavascriptObject(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate let webview: WebView = {
        let webview = WebView()
        return webview
    }()
}
