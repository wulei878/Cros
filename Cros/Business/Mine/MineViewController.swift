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
    //MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        if let url = URL(string: baseURL + "wallet-web/#/userPage") {
            let request = URLRequest(url: url)
            webview.load(request)
        }
        webview.navigationDelegate = self
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
    //MARK:- event response
    func addJavaScript() {
        let context = JSContext()
        context["getUUID"] = 
    }
    //MARK:- getter and setter
    fileprivate let webview: WebView = {
        let webview = WebView()
        return webview
    }()
}

//MARK:- delegate
extension MineViewController:WKNavigationDelegate {
}
