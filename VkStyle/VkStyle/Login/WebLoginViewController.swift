//
//  WebLoginViewController.swift
//  VkStyle
//
//  Created by aprirez on 9/26/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import WebKit
import Alamofire

class WebLoginViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        login()
    }
    
    func login() {
        let scope = 262150 | (1 << 16) // 'offline' token - no time limit
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7609671"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: String(scope)),
            URLQueryItem(name: "response_type", value: "token"),
            // URLQueryItem(name: "revoke", value: "1"), // if you need to exit VK
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
    }
}

extension WebLoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = URLHelpers.urlParamsToDict(fragment)
        
        Session.instance.token = params["access_token"] ?? ""
        let user_id = params["user_id"] ?? "0"
        Session.instance.userId = Int(user_id) ?? 0
        
        decisionHandler(.cancel)
        
        self.performSegue(withIdentifier: "DidLogin", sender: self)
    }
}
