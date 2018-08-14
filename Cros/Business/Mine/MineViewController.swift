//
//  MineViewController.swift
//  Cros
//
//  Created by Owen on 2018/8/5.
//  Copyright © 2018年 Wu Lei. All rights reserved.
//

import UIKit
import WebKit

class MineViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        let urlStr = h5BaseURL + "userPage?\(arc4random())"
//        let urlStr = "http://10.1.99.31:3000"
        webview.loadUrl(urlStr)
        webview.navigationDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didLogin), name: kLoginSucceedNotification, object: nil)
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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //选择相册中的图片完成，进行获取二维码信息
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageData = UIImagePNGRepresentation(image.scaleImage(width: 200)) {
            let encodeStr = imageData.base64EncodedString()
            getHeaderImageHandle?(encodeStr, true)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @objc func didLogin() {
        webview.reload()
    }
    // MARK: - getter and setter
    fileprivate let webview: WebView = {
        let webview = WebView()
        return webview
    }()

    var getHeaderImageHandle: ((String, Bool) -> Void)?
}

extension MineViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("succeed")
        webview.scrollView.mj_header.endRefreshing()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webview.scrollView.mj_header.endRefreshing()
    }
}
