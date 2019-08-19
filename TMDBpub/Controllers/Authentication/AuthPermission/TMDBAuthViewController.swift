//
//  TMDBAuthViewController.swift
//  UpcomingMovies
//
//  Created by Maksim Nosov on 19/08/2019.
//  Copyright © 2019 Alonso. All rights reserved.
//

import UIKit
import WebKit

// MARK: - TMDBAuthViewController: UIViewController

class TMDBAuthViewController: UIViewController {
    
    // MARK: Properties
    
    var urlRequest: URLRequest? = nil
    var requestToken: String? = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    
    // MARK: Outlets
    
    
    lazy var webConfiguration: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        return config
    }()
    
    var webView: WKWebView = {
        let wv = WKWebView()
        wv.backgroundColor = .gray
        return wv
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        
        navigationItem.title = "TheMovieDB Auth"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let urlRequest = urlRequest {
            webView.load(urlRequest)
//            webView.loadRequest(urlRequest)
        }
    }
    
    // MARK: Cancel Auth Flow
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - TMDBAuthViewController: UIWebViewDelegate

extension TMDBAuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let requestToken = requestToken else { return }
        
        if webView.url?.absoluteString == "\(Constants.AuthorizationURL)\(requestToken)/allow" {
            
            print("Allowed", webView.url?.absoluteString)
            dismiss(animated: true) {
                self.completionHandlerForView!(true, nil)
            }
        }
    }
    
}
