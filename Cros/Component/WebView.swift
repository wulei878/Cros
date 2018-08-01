//
//  BaseWebView.swift
//  Alamofire
//
//  Created by owen on 2018/7/18.
//

import Foundation
import WebKit

class WebView: WKWebView {
    var canPerformActions = [Selector: Bool]()
    var allowedSystemItems = [#selector(select(_:)),
                              #selector(selectAll(_:)),
                              #selector(copy(_:)),
                              #selector(paste(_:))]

    init() {
        super.init(frame: .zero, configuration: WebView.getDefaultConfig())
        setupContextMenuDefaultActions()
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

    func setupContextMenuDefaultActions() {
        self.allowedSystemItems.forEach { (sector) in
            self.canPerformActions[sector] = true
        }
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
