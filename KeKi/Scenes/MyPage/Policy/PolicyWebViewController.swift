//
//  PolicyWebViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/01.
//

import UIKit
import WebKit

class PolicyWebViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var urlString: String? = nil
    
    @IBOutlet var weViewGroup: UIView!
    @IBOutlet weak var webView: WKWebView!

    // MARK: - Methods of LifeCycle
    override func loadView() {
        super.loadView()
        if urlString != nil {
            webView = WKWebView(frame: self.view.frame)
            webView.uiDelegate = self
            webView.navigationDelegate = self
            self.view = self.webView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = urlString {
            print(urlString)
            let url = URL(string: urlString)
            let request = URLRequest(url: url!)
            webView.configuration.preferences.javaScriptEnabled = true  //자바스크립트 활성화
            webView.load(request)
        }
    }

    // MARK: - Helper Methods (Setup Method, ...)
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() } //모달창 닫힐때 앱 종료현상 방지.
    
    public func setUrlString(urlString: String) { self.urlString = urlString }
    

}

// MARK: - Extensions
extension PolicyWebViewController: WKUIDelegate, WKNavigationDelegate {
    //alert 처리
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler() }))
        self.present(alertController, animated: true, completion: nil)
        
    }

    //confirm 처리
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(false) }))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler(true) }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // href="_blank" 처리
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil { webView.load(navigationAction.request) }
        return nil
    }
}

