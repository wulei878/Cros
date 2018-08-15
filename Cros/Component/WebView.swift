//
//  BaseWebView.swift
//  Alamofire
//
//  Created by owen on 2018/7/18.
//

import Foundation
import dsBridge

class WebView: DWKWebView {
    var allowedSystemItems = [#selector(select(_:)),
                              #selector(selectAll(_:)),
                              #selector(copy(_:)),
                              #selector(paste(_:))]

    init() {
        super.init(frame: .zero, configuration: WebView.getDefaultConfig())
//        customJavascriptDialogLabelTitles(["alertTitle": "Notification", "alertBtn": "OK"])
        scrollView.mj_header = RefreshHeader(refreshingBlock: {[weak self] in
            self?.reload()
        })
//        setDebugMode(true)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    fileprivate static func getDefaultConfig() -> WKWebViewConfiguration {
        let userContentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        return config
    }

    func render(url: String) {
        self.evaluateJavaScript("window.render(\(url)", completionHandler: nil)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return allowedSystemItems.contains { $0 == action }
    }

    override func copy(_ sender: Any?) {
        guard let _ = sender as? UIMenuController else { return }
        callHandler("copyString", arguments: nil)
    }

    func removeMemoryCache() {
        removeCache(type: WKWebsiteDataTypeMemoryCache)
    }

    func removeDiskCache() {
        removeCache(type: WKWebsiteDataTypeDiskCache)
    }

    fileprivate func removeCache(type: String) {
        WKWebsiteDataStore.default().removeData(ofTypes: [type], modifiedSince: Date(timeIntervalSince1970: 0)) {}
    }
}
