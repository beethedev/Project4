//
//  WebViewController.swift
//  Project4
//
//  Created by Oluwabusayo Olorunnipa on 7/1/21.
//  Modified on 7/6/21

import UIKit
import WebKit

class WebViewController: UIViewController , WKNavigationDelegate {
    @IBOutlet var WebBrowser: UIView!
    var webView: WKWebView!
    var progressView: UIProgressView!
    var siteList = [String]()
    var website: String?
        
        override func loadView() {
            webView = WKWebView()
            webView.navigationDelegate = self
            view = webView
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
            
            let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
                
            let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
            
            progressView = UIProgressView(progressViewStyle: .default)
            progressView.sizeToFit()
            let progressButton = UIBarButtonItem(customView: progressView)
            
            toolbarItems = [back, spacer, progressButton, spacer, forward, spacer, refresh]
            navigationController?.isToolbarHidden = false
            
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            
            //let url = URL(string: "https://" + websites[1])!
            let url = URL(string: "https://" + website!)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
        
        
       @objc func openTapped() {
            let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
            for website in siteList {
                ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(ac, animated: true)
        }
        
         //Use guard let instead of force unwapping to be extra safe
        func openPage(action: UIAlertAction) {
            guard let actionTitle = action.title else { return }
            guard let url = URL(string: "https://" + actionTitle) else { return }
            webView.load(URLRequest(url: url))
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            title = webView.title
        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress" {
                progressView.progress = Float(webView.estimatedProgress)
            }
            
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let url = navigationAction.request.url
            
            if let host = url?.host {
                for site in siteList {
                    if host.contains(site){
                        decisionHandler(.allow)
                        return
                    }
                }
                let ac = UIAlertController(title: "Sorry", message: "You are not allowed to visit that site", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
                present(ac, animated: true)
                
            }
            decisionHandler(.cancel)
        }
        
    }
