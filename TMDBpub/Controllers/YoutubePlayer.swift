//
//  YoutubePlayer.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 16/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import WebKit

class YoutubePlayer: UIViewController {
    
    let key: String!
    
    lazy var webConfiguration: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        return config
    }()
    
    lazy var wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
    
    init(key: String) {
        self.key = key
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadYoutube(videoID: key)
        view.addSubview(wkWebView)
        wkWebView.fillSuperview()
    }
    
    func loadYoutube(videoID: String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)?&autoplay=1")
//                ?playsinline=1")
            else { return }
        print(youtubeURL)
                wkWebView.load( URLRequest(url: youtubeURL) )
        //        print(youtubeURL.absoluteString)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
