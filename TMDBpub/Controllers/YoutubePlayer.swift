//
//  YoutubePlayer.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 16/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import WebKit

extension WKWebView {
    override open var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension UIViewController {
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.5) {
        if self.tabBarController?.tabBar.isHidden != hidden{
            if animated {
                //Show the tabbar before the animation in case it has to appear
                if (self.tabBarController?.tabBar.isHidden)!{
                    self.tabBarController?.tabBar.isHidden = hidden
                }
                if let frame = self.tabBarController?.tabBar.frame {
                    let factor: CGFloat = hidden ? 1 : -1
                    let y = frame.origin.y + (frame.size.height * factor)
                    UIView.animate(withDuration: duration, animations: {
                        self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                    }) { (bool) in
                        //hide the tabbar after the animation in case ti has to be hidden
                        if (!(self.tabBarController?.tabBar.isHidden)!){
                            self.tabBarController?.tabBar.isHidden = hidden
                        }
                    }
                }
            }
        }
    }

class YoutubePlayer: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    let key: String!
    var didLoadVideo = false
    var widthVideo: CGFloat = 900
    var heightVideo: CGFloat = 720
//    var countFullscreen = 0
    var countStopped = 0
    
    var timer: Timer?
    
    lazy var webConfiguration: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        return config
    }()
    
    var webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()
    
    var mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.constrainWidth(constant: UIScreen.main.bounds.width)
        view.constrainHeight(constant: 240)
        return view
    }()
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
    
    init(key: String) {
        self.key = key
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

//        self?.setTabBarHidden()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // remove video listeners
        NotificationCenter.default.removeObserver(self, name: UIWindow.didBecomeVisibleNotification, object: view.window)
        NotificationCenter.default.removeObserver(self, name: UIWindow.didBecomeHiddenNotification, object: view.window)
//        toggleTabbar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Size of the webView is used to size the YT player frame in the JS code
        // and the size of the webView is only known in 'viewDidLayoutSubviews',
        // however, this function is called again once the HTML is loaded, so need
        // to store a bool indicating whether the HTML has already been loaded once
        
        if !didLoadVideo {
            
            webView.loadHTMLString(embedVideoHtml, baseURL: nil)
            didLoadVideo = true
            
            mainView.addSubview(webView)
            webView.centerInSuperview()
//            webView.constrainWidth(constant: mainView.frame.width)
//            webView.constrainHeight(constant: mainView.frame.height)
            mainView.alpha = 0
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
                self.showActivityIndicator(show: true)
            })
        }
        
//        countFullscreen += 1
        countStopped += 1
        
        
//        mainView = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        mainView.centerInSuperview()
        
        webView.constrainWidth(constant: mainView.frame.width)
        webView.constrainHeight(constant: mainView.frame.height)
        
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
//        webView.uiDelegate = self
//        webView.navigationDelegate = self
        
        NotificationCenter.default.addObserver(
            forName: UIWindow.didResignKeyNotification,
            object: self.view.window,
            queue: nil
        ) { [weak self] notification in
                self?.showActivityIndicator(show: false)
                self?.mainView.alpha = 1
//                print("Video is now fullscreen.", self?.countFullscreen)
        }
        
        
        NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeKeyNotification,
            object: self.view.window,
            queue: nil
        ) { [weak self] notification in
            self?.countStopped += 1
//                print("Video stopped.", self?.countStopped)
            
            if (self?.countStopped ?? 3 > 2 ) {
                self?.mainView.alpha = 0
                _ = self?.navigationController?.popViewController(animated: true)
                
            }
        }
        
        view.backgroundColor = .clear
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = view.frame.size.width
        let height = view.frame.size.height
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: width, height: height), configuration: webConfiguration)
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        
    }
    
    var embedVideoHtml: String {
        return """
        <!DOCTYPE html>
        <html>
        <body>
        <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
        <div id="player"></div>
        
        <script>
        var tag = document.createElement('script');
        
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
        
        var player;
        function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
        height: '\(heightVideo)',
        width: '\(widthVideo)',
        videoId: '\(key ?? "")',
        events: {
        'onReady': onPlayerReady
        }
        });
        }
        
        function onPlayerReady(event) {
        event.target.playVideo();
        }
        </script>
        </body>
        </html>
        """
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        showActivityIndicator(show: false)
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        showActivityIndicator(show: true)
//    }

//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        showActivityIndicator(show: false)
//    }
    
    
//    public func webViewDidStartLoad(_ webView: WKWebView)
//    {
//        activityIndicator.center =  CGPoint(x: self.view.bounds.size.width/2, y: self.view.bounds.size.height/2)
//        self.view.addSubview(activityIndicator)
//        activityIndicator.color = UIColor.red
//        self.activityIndicator.startAnimating()
//    }
//
//    public func webViewDidFinishLoad(_ webView: UIWebView)
//    {
//        self.activityIndicator.stopAnimating()
//    }
    
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if let serverTrust = challenge.protectionSpace.serverTrust {
//            completionHandler(.useCredential, URLCredential(trust: serverTrust))
//        }
//    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//    func loadYoutube(videoID: String) {
//        guard
//            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?autoplay=1")
////                            ?playsinline=1")
////            ?&autoplay=1")
//            else { return }
//        print(youtubeURL)
//        wkWebView.load( URLRequest(url: youtubeURL) )
//        //        print(youtubeURL.absoluteString)
//
//    }




//class YoutubePlayer: UIViewController {
//
//    let key: String!
//
//    lazy var webConfiguration: WKWebViewConfiguration = {
//        let config = WKWebViewConfiguration()
//        config.allowsInlineMediaPlayback = true
////        config.mediaTypesRequiringUserActionForPlayback = []
//        return config
//    }()
//
//    lazy var wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
//
//    init(key: String) {
//        self.key = key
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        loadYoutube(videoID: key)
//        view.addSubview(wkWebView)
//        wkWebView.fillSuperview()
//    }
//
//    func loadYoutube(videoID: String) {
//        guard
//            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?&autoplay=1")
////                ?playsinline=1")
//            else { return }
//        print(youtubeURL)
//                wkWebView.load( URLRequest(url: youtubeURL) )
//        wkWebView
//        //        print(youtubeURL.absoluteString)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError()
//    }
//}
}
