//
//  PaymentWebViewController.swift
// NewBase
//
//  Created by Mohamed Hadwa on 10/07/2025.
//
import UIKit
import WebKit

class PaymentWebViewController: UIViewController, WKNavigationDelegate {
    
//    var url: URL!
//    private var webView: WKWebView!
//    
//    var onPaymentAccepted: VoidCompletion?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = "Payment".localized
//      
//        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Cancel".localized,
//            style: .plain,
//            target: self,
//            action: #selector(cancelTapped)
//        )
//        
//        webView = WKWebView(frame: view.bounds)
//        webView.navigationDelegate = self
//        view.addSubview(webView)
//        
//        let request = URLRequest(url: url)
//        webView.load(request)
//    }
//    
//    @objc private func cancelTapped() {
//        dismiss(animated: true)
//    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
//                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//        if let urlStr = navigationAction.request.url?.absoluteString {
//            
//            if urlStr.contains("orders/accepted-form") {
//                print("✅ Payment Accepted! URL: \(urlStr)")
//                
//                dismiss(animated: true) {
//                    self.onPaymentAccepted?()
//                }
//                
//                decisionHandler(.cancel)
//                return
//            }
//            else if urlStr.contains("/payment/get-payment-status") {
//                print("✅ Navigated to Payment Status URL: \(urlStr)")
//                
//                dismiss(animated: true) {
//                    print("🚀 Executing another action because user navigated to payment status URL")
//                    
//                    self.onPaymentAccepted?()
//                }
//                
//                decisionHandler(.cancel)
//                return
//            }
//        }
//        
//        decisionHandler(.allow)
//    }
}
